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
    __weak __typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter]
        addObserverForName:ApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue]
        usingBlock:^(NSNotification* note) {
            [weakSelf releaseInitialFactory];
        }];

    [self swizzleSetDelegateMethodOnApplicationClass];
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
    initialFactory = [TyphoonBlockComponentFactory factoryFromPlistInBundle:[NSBundle mainBundle]];
}

+ (TyphoonComponentFactory*)initialFactory
{
    return initialFactory;
}

+ (void)swizzleSetDelegateMethodOnApplicationClass
{
    SEL sel = @selector(setDelegate:);
    Method method = class_getInstanceMethod(ApplicationClass, sel);

    void(*originalImp)(id, SEL, id) = (void (*)(id, SEL, id))method_getImplementation(method);

    IMP adjustedImp = imp_implementationWithBlock(^(id instance, id delegate) {
        [self loadInitialFactory];
        id factoryFromDelegate = [self factoryFromAppDelegate:delegate];
        if (factoryFromDelegate && initialFactory)
        {
            [NSException raise:NSInternalInconsistencyException
                format:@"The method 'initialFactory' is implemented on %@, also Info.plist"
                           " has 'TyphoonInitialAssemblies' key. Typhoon can't decide which factory to use.",
                       [delegate class]];
        }
        if (factoryFromDelegate)
        {
            initialFactory = factoryFromDelegate;
        }
        if (initialFactory)
        {
            [self injectInitialFactoryIntoDelegate:delegate];
            [TyphoonComponentFactory setFactoryForResolvingFromXibs:initialFactory];
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
    [initialFactory registerInstance:appDelegate asSingletonForDefinition:definition];
}


@end