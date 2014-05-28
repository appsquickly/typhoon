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
#import "TyphoonAssistedFactoryDefinition.h"

#import "TyphoonAssistedFactoryMethodBlock.h"

@interface TyphoonAssistedFactoryDefinitionTest : XCTestCase
@end

@implementation TyphoonAssistedFactoryDefinitionTest
{
    TyphoonAssistedFactoryDefinition *factoryDefinition;
}

- (void)setUp
{
    factoryDefinition = [[TyphoonAssistedFactoryDefinition alloc] init];
}

- (void)test_configure_should_inject_factory_itself_as_argument
{
    [factoryDefinition configure:^(TyphoonAssistedFactoryDefinition *definition) {
        XCTAssertEqual(definition, factoryDefinition);
    }];
}

- (void)test_countOfFactoryMethods_should_return_zero_for_no_methods
{
    XCTAssertEqual(factoryDefinition.countOfFactoryMethods, 0);
}

- (void)test_countOfFactoryMethod_should_return_one_for_just_one_method
{
    [factoryDefinition factoryMethod:@selector(wadus) body:^{
    }];

    XCTAssertEqual(factoryDefinition.countOfFactoryMethods, 1);
}

- (void)test_countOfFactoryMethod_should_return_the_number_of_factory_methods
{
    [factoryDefinition factoryMethod:@selector(wadus) body:^{
    }];
    [factoryDefinition factoryMethod:@selector(wadusWithWadus:) body:^{
    }];
    [factoryDefinition factoryMethod:@selector(wadusWithWadus:andWadus:) body:^{
    }];

    XCTAssertEqual(factoryDefinition.countOfFactoryMethods, 3);
}

- (void)test_enumerateFactoryMethods_should_invoke_block_for_no_methods
{
    __block int count = 0;

    [factoryDefinition enumerateFactoryMethods:^(id <TyphoonAssistedFactoryMethod> factoryMethod) {
        count += 1;
    }];

    XCTAssertEqual(count, 0);
}

- (void)test_enumerateFactoryMethods_should_invoke_block_for_number_of_factory_methods
{
    [factoryDefinition factoryMethod:@selector(wadus) body:^{
    }];
    [factoryDefinition factoryMethod:@selector(wadusWithWadus:) body:^{
    }];
    [factoryDefinition factoryMethod:@selector(wadusWithWadus:andWadus:) body:^{
    }];
    __block int count = 0;

    [factoryDefinition enumerateFactoryMethods:^(id <TyphoonAssistedFactoryMethod> factoryMethod) {
        count += 1;
    }];

    XCTAssertEqual(count, 3);
}

- (void)test_enumerateFactoryMethods_should_invoke_block_with_configured_selector
{
    SEL selector = @selector(wadusWithWadus:andWadus:);
    [factoryDefinition factoryMethod:selector body:^{
    }];

    [factoryDefinition enumerateFactoryMethods:^(id <TyphoonAssistedFactoryMethod> factoryMethod) {
        XCTAssertEqualObjects(NSStringFromSelector(factoryMethod.factoryMethod), @"wadusWithWadus:andWadus:");
    }];
}

- (void)test_enumerateFactoryMethods_should_invoke_block_with_configured_body
{
    id (^bodyBlock)(id) = ^id(id factory) {
        return nil;
    };

    [factoryDefinition factoryMethod:@selector(wadus) body:bodyBlock];

    [factoryDefinition enumerateFactoryMethods:^(TyphoonAssistedFactoryMethodBlock *factoryMethod) {
        XCTAssertEqualObjects(factoryMethod.bodyBlock, bodyBlock);
    }];
}

@end
