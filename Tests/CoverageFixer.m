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


#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestingKit.h>

@interface CoverageFixer : SenTestLog
@end

@implementation CoverageFixer

extern void __gcov_flush(void);


+ (void)testSuiteDidStop:(NSNotification*)aNotification
{
    __gcov_flush();
    [super testSuiteDidStop:aNotification];
}

@end

