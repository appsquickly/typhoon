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


#import "TyphoonAppDelegate.h"
#import "TyphoonInjections.h"
#import "TyphoonConfigPostProcessor.h"
#import "TyphoonIntrospectionUtils.h"


@implementation TyphoonAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Force linking for on-device testing

    TyphoonInjectionWithReference(nil);
    TyphoonConfig(@"");

    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    extern void __gcov_flush(void);
    __gcov_flush();
}


@end
