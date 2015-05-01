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
#import "TyphoonViewControllerNibResolver.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonDefinition+Infrastructure.h"

@interface TyphoonViewControllerNibResolverTests : XCTestCase
{
    TyphoonViewControllerNibResolver *_nibResolver;
}

@end

@implementation TyphoonViewControllerNibResolverTests

- (void)setUp
{
    [super setUp];
    _nibResolver = [[TyphoonViewControllerNibResolver alloc] init];
}

- (void)test_process_view_controller_without_initializer
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[UIViewController class]];

    [_nibResolver postProcessDefinition:definition replacement:NULL withFactory:nil];

    XCTAssertNotNil(definition.initializer);
    XCTAssertEqualObjects(NSStringFromSelector(definition.initializer.selector), NSStringFromSelector(@selector(initWithNibName:bundle:)));
    XCTAssertEqual([[definition.initializer injectedParameters] count], 2);

}

- (void)test_skips_view_controller_with_initializer
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[UIViewController class]];

    [definition useInitializer:@selector(initWithFoobar:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:@""];
    }];

    [_nibResolver postProcessDefinition:definition replacement:NULL withFactory:nil];

    XCTAssertEqualObjects(NSStringFromSelector(definition.initializer.selector), NSStringFromSelector(@selector(initWithFoobar:)));
}


- (void)test_resolves_nib_name_from_class
{
    Class clazz = [UIViewController class];
    NSString *nibName = [_nibResolver resolveNibNameForClass:clazz];
    XCTAssertEqualObjects(nibName, NSStringFromClass(clazz));
}

@end
