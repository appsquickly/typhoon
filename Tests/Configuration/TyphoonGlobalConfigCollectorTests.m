////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>
#import <OCMockitoIOS/OCMockitoIOS.h>

#import "TyphoonGlobalConfigCollector.h"
#import "TyphoonConfigAppDelegateMock.h"

@interface TyphoonGlobalConfigCollectorTests : XCTestCase

@end

@implementation TyphoonGlobalConfigCollectorTests

- (void)test_collector_fetches_plist
{
    TyphoonGlobalConfigCollector *collector = [[TyphoonGlobalConfigCollector alloc] initWithAppDelegate:nil];
    NSBundle *testBundle = MKTMock([NSBundle class]);
    
    NSArray *expectedNames = @[@"config.plist"];
    NSDictionary *testBundleInfo = @{
                                     @"TyphoonGlobalConfigFilenames" : expectedNames
                                     };
    
    [given([testBundle infoDictionary]) willReturn:testBundleInfo];
    
    NSArray *result = [collector obtainGlobalConfigFilenamesFromBundle:testBundle];
    
    [self verifyResult:result withExpectedNames:expectedNames];
}

- (void)test_collector_fetches_app_delegate
{
    TyphoonConfigAppDelegateMock *appDelegateMock = [TyphoonConfigAppDelegateMock new];
    TyphoonGlobalConfigCollector *collector = [[TyphoonGlobalConfigCollector alloc] initWithAppDelegate:appDelegateMock];
    
    NSArray *expectedNames = @[@"config.plist"];
    appDelegateMock.fileNames = expectedNames;
    
    NSArray *result = [collector obtainGlobalConfigFilenamesFromBundle:nil];
    
    [self verifyResult:result withExpectedNames:expectedNames];
}

- (void)test_collector_fetches_unique_bundle_id
{
    NSBundle *testBundle = [self generateTestBundleWithBundleIdBakedConfig];
    TyphoonGlobalConfigCollector *collector = [[TyphoonGlobalConfigCollector alloc] initWithAppDelegate:nil];
    
    NSArray *expectedNames = @[@"config_test.plist"];
    NSArray *result = [collector obtainGlobalConfigFilenamesFromBundle:testBundle];
    
    [self verifyResult:result withExpectedNames:expectedNames];
}

- (void)test_collector_fetches_old_style_plist
{
    TyphoonGlobalConfigCollector *collector = [[TyphoonGlobalConfigCollector alloc] initWithAppDelegate:nil];
    NSBundle *testBundle = MKTMock([NSBundle class]);
    
    NSArray *expectedNames = @[@"config.plist"];
    NSDictionary *testBundleInfo = @{
                                     @"TyphoonConfigFilename" : @"config.plist"
                                     };
    
    [given([testBundle infoDictionary]) willReturn:testBundleInfo];
    
    NSArray *result = [collector obtainGlobalConfigFilenamesFromBundle:testBundle];
    
    [self verifyResult:result withExpectedNames:expectedNames];
}

#pragma mark - Helper methods

- (void)verifyResult:(NSArray *)result withExpectedNames:(NSArray *)expectedNames
{
    XCTAssertEqual(result.count, expectedNames.count);
    
    for (NSString *resultName in result) {
        NSUInteger index = [result indexOfObject:resultName];
        XCTAssertEqualObjects(resultName, expectedNames[index]);
    }
}

- (NSBundle *)generateTestBundleWithBundleIdBakedConfig {
    NSString *bundleId = @"test";
    NSString *configFileName = @"config_test.plist";
    NSBundle *testBundle = MKTMock([NSBundle class]);
    NSDictionary *testBundleInfo = @{
                                     @"CFBundleIdentifier" : bundleId
                                     };
    [given([testBundle infoDictionary]) willReturn:testBundleInfo];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [given([testBundle resourcePath]) willReturn:documentsDirectory];
    NSString *configPath = [documentsDirectory stringByAppendingPathComponent:configFileName];
    NSData *testData = [configFileName dataUsingEncoding:NSUTF8StringEncoding];
    
    [[NSFileManager defaultManager] createFileAtPath:configPath
                                            contents:testData
                                          attributes:nil];
    
    return testBundle;
}

@end
