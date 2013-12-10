////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "VATestObserver.h"
#import <UIKit/UIKit.h>


static id mainSuite = nil;

@implementation VATestObserver

+ (void)initialize
{
    [[NSUserDefaults standardUserDefaults] setValue:@"VATestObserver" forKey:SenTestObserverClassKey];

    [super initialize];
}

+ (void)testSuiteDidStart:(NSNotification*)notification
{
    [super testSuiteDidStart:notification];

    SenTestSuiteRun* suite = notification.object;

    if (mainSuite == nil)
    {
        mainSuite = suite;
    }
}

+ (void)testSuiteDidStop:(NSNotification*)notification
{
    [super testSuiteDidStop:notification];

    SenTestSuiteRun* suite = notification.object;

    if (mainSuite == suite)
    {
        UIApplication* application = [UIApplication sharedApplication];
        [application.delegate applicationWillTerminate:application];
    }
}

extern void __gcov_flush(void);

- (void)applicationWillTerminate:(UIApplication*)application
{
    __gcov_flush();
}

@end

