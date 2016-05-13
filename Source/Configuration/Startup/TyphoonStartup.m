////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonStartup.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonAssembly.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonConfigPostProcessor.h"
#import "OCLogTemplate.h"
#import "TyphoonAssemblyBuilder+PlistProcessor.h"
#import "TyphoonAssemblyBuilder.h"
#import "TyphoonGlobalConfigCollector.h"

#import <objc/runtime.h>

#if TARGET_OS_IPHONE || TARGET_OS_TV
#define ApplicationClass [UIApplication class]
#elif TARGET_OS_MAC
#define ApplicationClass [NSApplication class]
#endif

#if TARGET_OS_IPHONE || TARGET_OS_TV
#define ApplicationDidFinishLaunchingNotification UIApplicationDidFinishLaunchingNotification
#elif TARGET_OS_MAC
#define ApplicationDidFinishLaunchingNotification NSApplicationDidFinishLaunchingNotification
#endif


@implementation TyphoonStartup

+ (void)load
{
    [self swizzleSetDelegateMethodOnApplicationClass];
}

+ (TyphoonComponentFactory *)factoryFromAppDelegate:(id)appDelegate
{
    TyphoonComponentFactory *result = nil;
    SEL initialFactorySelector = NSSelectorFromString(@"initialFactory");
    SEL initialAssembliesSelector = NSSelectorFromString(@"initialAssemblies");
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([appDelegate respondsToSelector:initialFactorySelector]) {
        result = [appDelegate performSelector:initialFactorySelector];
    }
    
    if ([appDelegate respondsToSelector:initialAssembliesSelector]) {
        NSArray *assemblyClasses = [appDelegate performSelector:initialAssembliesSelector];
        NSArray *assemblies = [TyphoonAssemblyBuilder buildAssembliesWithClasses:assemblyClasses];
        result = [TyphoonBlockComponentFactory factoryWithAssemblies:assemblies];
    }
#pragma clang diagnostic pop
    
    return result;
}

#pragma mark -

static TyphoonComponentFactory *initialFactory;
static NSUInteger initialFactoryRequestCount = 0;
static BOOL initialFactoryWasCreated = NO;

+ (void)requireInitialFactory
{
    if (initialFactoryRequestCount == 0 && !initialFactoryWasCreated) {
        NSArray *assemblies = [TyphoonAssemblyBuilder buildAssembliesFromPlistInBundle:[NSBundle mainBundle]];
        if (assemblies.count > 0) {
            initialFactory = [TyphoonBlockComponentFactory factoryWithAssemblies:assemblies];
            initialFactoryWasCreated = YES;
        }
    }
    initialFactoryRequestCount += 1;
}

+ (TyphoonComponentFactory *)initialFactory
{
    return initialFactory;
}

+ (void)swizzleSetDelegateMethodOnApplicationClass
{
    SEL sel = @selector(setDelegate:);
    Method method = class_getInstanceMethod(ApplicationClass, sel);

    void(*originalImp)(id, SEL, id) = (void (*)(id, SEL, id))method_getImplementation(method);

    IMP adjustedImp = imp_implementationWithBlock(^(id instance, id delegate) {
        [self requireInitialFactory];
        id factoryFromDelegate = [self factoryFromAppDelegate:delegate];
        if (factoryFromDelegate && initialFactory) {
            [NSException raise:NSInternalInconsistencyException
                format:@"The method 'initialFactory' is implemented on %@, also Info.plist"
                           " has 'TyphoonInitialAssemblies' key. Typhoon can't decide which factory to use.",
                       [delegate class]];
        }
        if (factoryFromDelegate) {
            initialFactory = factoryFromDelegate;
        }
        if (initialFactory) {
            TyphoonGlobalConfigCollector *collector = [[TyphoonGlobalConfigCollector alloc] initWithAppDelegate:delegate];
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSArray *globalConfigFileNames = [collector obtainGlobalConfigFilenamesFromBundle:bundle];
            for (NSString *configName in globalConfigFileNames) {
                id<TyphoonDefinitionPostProcessor> configProcessor = [TyphoonConfigPostProcessor forResourceNamed:configName inBundle:bundle];
                [initialFactory attachDefinitionPostProcessor:configProcessor];
            }

            [self injectInitialFactoryIntoDelegate:delegate];
            [TyphoonComponentFactory setFactoryForResolvingUI:initialFactory];
        }
        [self releaseInitialFactoryWhenApplicationDidFinishLaunching];

        originalImp(instance, sel, delegate);
    });

    method_setImplementation(method, adjustedImp);
}

+ (void)releaseInitialFactoryWhenApplicationDidFinishLaunching
{
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter]
        addObserverForName:ApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue]
        usingBlock:^(NSNotification *note) {
            [weakSelf releaseInitialFactory];
        }];
}

+ (void)releaseInitialFactory
{
    initialFactoryRequestCount -= 1;
    if (initialFactoryRequestCount == 0) {
        initialFactory = nil;
    }
}

#pragma mark -

+ (void)injectInitialFactoryIntoDelegate:(id)appDelegate
{
    [initialFactory load];
    [initialFactory inject:appDelegate];
}

@end
