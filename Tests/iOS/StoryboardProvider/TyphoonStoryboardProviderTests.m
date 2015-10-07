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

#import "TyphoonStoryboardProvider.h"

@interface TyphoonStoryboardProviderTests : XCTestCase

@property (strong, nonatomic) TyphoonStoryboardProvider *provider;
@property (strong, nonatomic) NSBundle *testBundle;

@end

@implementation TyphoonStoryboardProviderTests

- (void)setUp {
    [super setUp];
    
    self.provider = [TyphoonStoryboardProvider new];
    
    self.testBundle = MKTMock([NSBundle class]);
    NSArray *testStoryboardsPaths = @[
                                      @"/Users/etolstoy/Library/Developer/CoreSimulator/Devices/2FCF21A0-E58A-4E87-BC8C-D63B33CEF2B8/data/Containers/Bundle/Application/68288B52-6B1F-4260-B817-23A90E320A5F/Typhoon-iOS.app/Storyboard1.storyboardc",
                                      @"/Users/etolstoy/Library/Developer/CoreSimulator/Devices/2FCF21A0-E58A-4E87-BC8C-D63B33CEF2B8/data/Containers/Bundle/Application/68288B52-6B1F-4260-B817-23A90E320A5F/Typhoon-iOS.app/Base.lproj/Storyboard2.storyboardc"
                                      ];
    [given([self.testBundle pathsForResourcesOfType:@"storyboardc" inDirectory:@""]) willReturn:testStoryboardsPaths];
    
}

- (void)tearDown {
    self.provider = nil;
    self.testBundle = nil;
    
    [super tearDown];
}

- (void)test_provider_returns_all_storyboards_in_bundle
{
    NSArray *expectedStoryboardNames = @[@"Storyboard1", @"Storyboard2"];
    
    NSArray *result = [self.provider collectStoryboardsFromBundle:self.testBundle];
    
    XCTAssertEqual(result.count, expectedStoryboardNames.count);
    
    for (NSString *resultName in result) {
        NSUInteger index = [result indexOfObject:resultName];
        XCTAssertEqualObjects(resultName, expectedStoryboardNames[index]);
    }
}

- (void)test_provider_filters_storyboards_with_black_list
{
    NSDictionary *testBundleInfo = @{
                                     @"TyphoonCleanStoryboards" : @[@"Storyboard1"]
                                     };
    NSArray *expectedStoryboardNames = @[@"Storyboard2"];
    
    [given([self.testBundle infoDictionary]) willReturn:testBundleInfo];
    
    NSArray *result = [self.provider collectStoryboardsFromBundle:self.testBundle];
    
    XCTAssertEqual(result.count, expectedStoryboardNames.count);
    
    for (NSString *resultName in result) {
        NSUInteger index = [result indexOfObject:resultName];
        XCTAssertEqualObjects(resultName, expectedStoryboardNames[index]);
    }
}

- (void)test_provider_returns_initial_storyboard_name
{
    NSString *initialStoryboardName = @"Main";
    NSDictionary *testBundleInfo = @{
                                     @"UIMainStoryboardFile" : initialStoryboardName
                                     };
    [given([self.testBundle infoDictionary]) willReturn:testBundleInfo];
    
    NSString *result = [self.provider obtainInitialStoryboardNameFromBundle:self.testBundle];
    
    XCTAssertEqualObjects(result, initialStoryboardName);
}

- (void)test_provider_returns_extension_storyboard_name
{
    NSString *initialStoryboardName = @"ExtensionMain";
    NSDictionary *testBundleInfo = @{
                                     @"NSExtension" : @{
                                             @"NSExtensionMainStoryboard" : initialStoryboardName
                                             }
                                     };
    [given([self.testBundle infoDictionary]) willReturn:testBundleInfo];
    
    NSString *result = [self.provider obtainInitialStoryboardNameFromBundle:self.testBundle];
    
    XCTAssertEqualObjects(result, initialStoryboardName);
}

@end
