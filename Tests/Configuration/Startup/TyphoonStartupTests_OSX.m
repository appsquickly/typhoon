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

#import <XCTest/XCTest.h>
#import "TyphoonOSXAppDelegate.h"

@interface TyphoonStartupTests_iOS : XCTestCase

@end

@implementation TyphoonStartupTests_iOS

- (void)test_loads_configuration
{
    id delegate = [NSApplication sharedApplication].delegate;
    XCTAssertEqual(12, [delegate damselsRescued]);
}

@end
