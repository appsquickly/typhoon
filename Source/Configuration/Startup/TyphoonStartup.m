//
// Created by Aleksey Garbarev on 05.06.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import "TyphoonStartup.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonAssembly.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import <objc/runtime.h>

#if TARGET_OS_IPHONE
#define ApplicationClass [UIApplication class]
#elif TARGET_OS_MAC
#define ApplicationClass [NSApplication class]
#endif

#if TARGET_OS_IPHONE
#define ApplicationDidFinishLaunchingNotification UIApplicationDidFinishLaunchingNotification
#elif TARGET_OS_MAC
#define ApplicationDidFinishLaunchingNotification NSApplicationDidFinishLaunchingNotification
#endif


@implementation TyphoonStartup

+ (void)load
{
    [self loadInitialFactory];

    __weak __typeof (self) weakSelf = self;
    [[NSNotificationCenter defaultCenter]
         addObserverForName:ApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [weakSelf releaseInitialFactory];
    }];

    [self swizzleSetDelegateMethodOnApplicationClass];
}

+ (TyphoonComponentFactory *)factoryFromPlist
{
    TyphoonComponentFactory *result = nil;

    NSArray *assemblyNames = [self plistAssemblyNames];
    NSAssert(!assemblyNames || [assemblyNames isKindOfClass:[NSArray class]], @"Value for 'TyphoonInitialAssemblies' key must be array");

    if ([assemblyNames count] > 0) {
        NSMutableArray *assemblies = [[NSMutableArray alloc] initWithCapacity:[assemblyNames count]];
        for (NSString *assemblyName in assemblyNames) {
            Class cls = NSClassFromString(assemblyName);
            if (!cls) {
                [NSException raise:NSInvalidArgumentException format:@"Can't resolve assembly for name %@", assemblyName];
            }
            [assemblies addObject:[cls assembly]];
        }
        result = [TyphoonBlockComponentFactory factoryWithAssemblies:assemblies];
    }

    return result;
}

+ (NSArray *)plistAssemblyNames
{
    NSArray *names = nil;

    NSDictionary *bundleInfoDictionary = [[NSBundle mainBundle] infoDictionary];
#if TARGET_OS_IPHONE
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        names = [bundleInfoDictionary objectForKey:@"TyphoonInitialAssemblies(iPad)"];
    } else {
        names = [bundleInfoDictionary objectForKey:@"TyphoonInitialAssemblies(iPhone)"];
    }
#endif
    if (!names) {
        names = [bundleInfoDictionary objectForKey:@"TyphoonInitialAssemblies"];
    }

    return names;
}

+ (TyphoonComponentFactory *)factoryFromAppDelegate:(id)appDelegate
{
    TyphoonComponentFactory *result = nil;

    if ([appDelegate respondsToSelector:@selector(initialFactory)]) {
        result = [appDelegate initialFactory];
    }

    return result;
}

#pragma mark -

static TyphoonComponentFactory *initialFactory;

+ (void)loadInitialFactory
{
    initialFactory = [self factoryFromPlist];
}

+ (TyphoonComponentFactory *)initialFactory
{
    return initialFactory;
}

+ (void)swizzleSetDelegateMethodOnApplicationClass
{
    SEL sel = @selector(setDelegate:);
    Method method = class_getInstanceMethod(ApplicationClass, sel);
    
    void(*originalImp)(id,SEL,id) = (void(*)(id,SEL,id))method_getImplementation(method);
    
    IMP adjustedImp = imp_implementationWithBlock(^(id instance, id delegate) {
        id factoryFromDelegate = [self factoryFromAppDelegate:delegate];
        if (factoryFromDelegate && initialFactory) {
            [NSException raise:NSInternalInconsistencyException format:@"The method 'initialFactory' is implemented on %@, also Info.plist"
                                                                           " has 'TyphoonInitialAssemblies' key. Typhoon can't decide which factory to use.", [delegate class]];
        }
        if (factoryFromDelegate) {
            initialFactory = factoryFromDelegate;
        }
        if (initialFactory) {
            [self injectInitialFactoryIntoDelegate:delegate];
        }

        originalImp(instance, sel, delegate);
    });
    
    method_setImplementation(method, adjustedImp);
}

+ (void)releaseInitialFactory
{
    initialFactory = nil;
}

#pragma mark -

+ (void)injectInitialFactoryIntoDelegate:(id)appDelegate
{
    [initialFactory load];
    TyphoonDefinition *definition = [[initialFactory allDefinitionsForType:[appDelegate class]] lastObject];
    [initialFactory doInjectionEventsOn:appDelegate withDefinition:definition args:nil];
}

@end