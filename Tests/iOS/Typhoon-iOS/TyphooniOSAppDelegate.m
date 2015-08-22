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


#import "TyphooniOSAppDelegate.h"
#import "TyphoonInjections.h"
#import "TyphoonConfigPostProcessor.h"
#import "TyphoonIntrospectionUtils.h"
#import "iOSPlistConfiguredAssembly.h"
#import "Knight.h"
#import "OCLogTemplate.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Force linking for on-device testing

    TyphoonInjectionWithReference(nil);
    TyphoonConfig(@"");

    LogDebug(@"$$$$$$$$$$ got assembly %@", _assembly);

    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    extern void __gcov_flush(void);
    __gcov_flush();
}

- (NSUInteger)damselsRescued
{
    Knight *knight = [_assembly configuredCavalryMan];
    LogDebug(@"Got knight: %@", knight);
    return knight.damselsRescued;
}


@end
