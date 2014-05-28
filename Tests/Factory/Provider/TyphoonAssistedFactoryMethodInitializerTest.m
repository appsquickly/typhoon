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

#import <XCTest/XCTest.h>
#import "TyphoonAssistedFactoryMethodInitializer.h"

#import "TyphoonAssistedFactoryParameterInjectedWithArgumentIndex.h"
#import "TyphoonAssistedFactoryParameterInjectedWithProperty.h"

@interface TyphoonAssistedFactoryInitializerTest : XCTestCase
@end

@implementation TyphoonAssistedFactoryInitializerTest
{
    SEL _factoryMethod;
    SEL _initializerMethod;
    TyphoonAssistedFactoryMethodInitializer *_initializer;
}

- (void)setUp
{
    _factoryMethod = @selector(stringWithContentsOfFile:encoding:error:);
    _initializerMethod = @selector(initWithContentsOfFile:encoding:error:);

    _initializer = [[TyphoonAssistedFactoryMethodInitializer alloc] initWithFactoryMethod:_factoryMethod returnType:[NSString class]];
    _initializer.selector = _initializerMethod;
}

- (void)test_after_init_factoryMethod_should_be_initializer_value
{
    XCTAssertEqual(strcmp(sel_getName(_factoryMethod), sel_getName(_initializer.factoryMethod)), 0);
}

- (void)test_after_init_selector_should_be_the_selector_value
{
    XCTAssertEqual(strcmp(sel_getName(_initializerMethod), sel_getName(_initializer.selector)), 0);
}

- (void)test_after_init_parameters_should_be_empty
{
    XCTAssertTrue([_initializer.parameters count] == 0);
}

- (void)test_after_init_countOfParameters_should_be_zero
{
    XCTAssertEqual([_initializer countOfParameters], 0);
}

- (void)behaviour_inject_common
{
    // inject should modify parameters array
    XCTAssertEqual([_initializer.parameters count], 1);

    // inject should increase countOfParameters
    XCTAssertEqual([_initializer countOfParameters], 1);
}

- (void)behaviour_inject_with_inexistent_parameter
{
    // inject should not modify parameters array
    XCTAssertTrue([_initializer.parameters count] == 0);

    // inject should not increase countOfParameters
    XCTAssertEqual([_initializer countOfParameters], 0);
}

- (void)test_injectWithProperty_should_follow_inject_commmon_behaviour
{
    [_initializer injectWithProperty:@selector(count)];
    [self behaviour_inject_common];
}

- (void)test_injectWithProperty_should_inject_properties_at_the_end
{
    [_initializer injectWithProperty:@selector(count)];
    [_initializer injectWithProperty:@selector(UTF8String)];

    id <TyphoonAssistedFactoryInjectedParameter> last = [_initializer.parameters lastObject];
    XCTAssertEqual([last parameterIndex], 1);
}

- (void)test_injectParameterNamed_withProperty_should_follow_inject_commmon_behaviour
{
    [_initializer injectParameterNamed:@"contentsOfFile" withProperty:@selector(count)];
    [self behaviour_inject_common];
}

- (void)test_injectParameterNamed_withProperty_should_follow_inject_with_inexistent_parameter_behaviour
{
    [_initializer injectParameterNamed:@"foo" withProperty:@selector(count)];
    [self behaviour_inject_with_inexistent_parameter];
}

- (void)test_injectParameterAtIndex_withProperty_should_follow_inject_commmon_behaviour
{
    [_initializer injectParameterAtIndex:0 withProperty:@selector(count)];
    [self behaviour_inject_common];
}

- (void)test_injectParameterAtIndex_withProperty_should_follow_inject_with_inexistent_parameter_behaviour
{
    [_initializer injectParameterAtIndex:3 withProperty:@selector(count)];
    [self behaviour_inject_with_inexistent_parameter];
}

- (void)test_injectParameterAtIndex_withProperty_should_create_correct_parameter_object
{
    SEL property = @selector(count);
    [_initializer injectParameterAtIndex:0 withProperty:property];

    TyphoonAssistedFactoryParameterInjectedWithProperty *parameter = [_initializer.parameters lastObject];

    XCTAssertTrue([parameter isKindOfClass:[TyphoonAssistedFactoryParameterInjectedWithProperty class]]);
    XCTAssertEqual(strcmp(sel_getName(parameter.property), sel_getName(property)), 0);
}

- (void)test_injectWithArgumentAtIndex_should_follow_inject_commmon_behaviour
{
    [_initializer injectWithArgumentAtIndex:0];
    [self behaviour_inject_common];
}

- (void)test_injectWithArgumentAtIndex_should_inject_properties_at_the_end
{
    [_initializer injectWithArgumentAtIndex:1];
    [_initializer injectWithArgumentAtIndex:0];

    id <TyphoonAssistedFactoryInjectedParameter> last = [_initializer.parameters lastObject];
    XCTAssertEqual([last parameterIndex], 1);
}

- (void)test_injectParameterNamed_withArgumentAtIndex_should_follow_inject_commmon_behaviour
{
    [_initializer injectParameterNamed:@"contentsOfFile" withArgumentAtIndex:0];
    [self behaviour_inject_common];
}

- (void)test_injectParameterNamed_withArgumentAtIndex_should_follow_inject_with_inexistent_parameter_behaviour
{
    [_initializer injectParameterNamed:@"foo" withArgumentAtIndex:0];
    [self behaviour_inject_with_inexistent_parameter];
}

- (void)test_injectParameterAtIndex_withArgumentAtIndex_should_follow_inject_commmon_behaviour
{
    [_initializer injectParameterAtIndex:0 withArgumentAtIndex:0];
    [self behaviour_inject_common];
}

- (void)test_injectParameterAtIndex_withArgumentAtIndex_should_follow_inject_with_inexistent_parameter_behaviour
{
    [_initializer injectParameterAtIndex:3 withArgumentAtIndex:0];
    [self behaviour_inject_with_inexistent_parameter];
}

- (void)test_injectParameterAtIndex_withArgumentAtIndex_should_not_create_parameter_with_inexistent_argument
{
    [_initializer injectParameterAtIndex:0 withArgumentAtIndex:3];

    XCTAssertTrue([_initializer.parameters count] == 0);
    XCTAssertEqual([_initializer countOfParameters], 0);
}

- (void)test_injectParameterAtIndex_withArgumentAtIndex_should_create_correct_parameter_object
{
    [_initializer injectParameterAtIndex:0 withArgumentAtIndex:1];

    TyphoonAssistedFactoryParameterInjectedWithArgumentIndex *parameter = [_initializer.parameters lastObject];

    XCTAssertTrue([parameter isKindOfClass:[TyphoonAssistedFactoryParameterInjectedWithArgumentIndex class]]);
    XCTAssertEqual(parameter.argumentIndex, 1);
}

- (void)test_injectWithArgumentNamed_should_follow_inject_commmon_behaviour
{
    [_initializer injectWithArgumentNamed:@"contentsOfFile"];
    [self behaviour_inject_common];
}

- (void)test_injectWithArgumentNamed_should_inject_properties_at_the_end
{
    [_initializer injectWithArgumentNamed:@"encoding"];
    [_initializer injectWithArgumentNamed:@"contentsOfFile"];

    id <TyphoonAssistedFactoryInjectedParameter> last = [_initializer.parameters lastObject];
    XCTAssertEqual([last parameterIndex], 1);
}

- (void)test_injectParameterNamed_withArgumentNamed_should_follow_inject_commmon_behaviour
{
    [_initializer injectParameterNamed:@"contentsOfFile" withArgumentNamed:@"contentsOfFile"];
    [self behaviour_inject_common];
}

- (void)test_injectParameterNamed_withArgumentNamed_should_follow_inject_with_inexistent_parameter_behaviour
{
    [_initializer injectParameterNamed:@"foo" withArgumentNamed:@"contentsOfFile"];
    [self behaviour_inject_with_inexistent_parameter];
}

- (void)test_injectParameterAtIndex_withArgumentNamed_should_follow_inject_commmon_behaviour
{
    [_initializer injectParameterAtIndex:0 withArgumentNamed:@"contentsOfFile"];
    [self behaviour_inject_common];
}

- (void)test_injectParameterAtIndex_withArgumentNamed_should_follow_inject_with_inexistent_parameter_behaviour
{
    [_initializer injectParameterAtIndex:3 withArgumentNamed:@"contentsOfFile"];
    [self behaviour_inject_with_inexistent_parameter];
}

- (void)test_injectParameterAtIndex_withArgumentNamed_should_not_create_parameter_with_inexistent_argument
{
    [_initializer injectParameterAtIndex:0 withArgumentNamed:@"foo"];

    XCTAssertTrue([_initializer.parameters count] == 0);
    XCTAssertEqual([_initializer countOfParameters], 0);
}

- (void)test_injectParameterAtIndex_withArgumentNamed_should_create_correct_parameter_object
{
    [_initializer injectParameterAtIndex:0 withArgumentNamed:@"encoding"];

    TyphoonAssistedFactoryParameterInjectedWithArgumentIndex *parameter = [_initializer.parameters lastObject];

    XCTAssertTrue([parameter isKindOfClass:[TyphoonAssistedFactoryParameterInjectedWithArgumentIndex class]]);
    XCTAssertEqual(parameter.argumentIndex, 1);
}

@end
