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

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonAssistedFactoryDefinition.h"

@interface TyphoonAssistedFactoryDefinitionTest : SenTestCase
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
        assertThat(definition, is(equalTo(factoryDefinition)));
    }];
}

- (void)test_countOfFactoryMethods_should_return_zero_for_no_methods
{
  assertThatInteger(factoryDefinition.countOfFactoryMethods, is(equalToInteger(0)));
}

- (void)test_countOfFactoryMethod_should_return_one_for_just_one_method
{
  [factoryDefinition factoryMethod:@selector(wadus) body:^{}];

  assertThatInteger(factoryDefinition.countOfFactoryMethods, is(equalToInteger(1)));
}

- (void)test_countOfFactoryMethod_should_return_the_number_of_factory_methods
{
  [factoryDefinition factoryMethod:@selector(wadus) body:^{}];
  [factoryDefinition factoryMethod:@selector(wadusWithWadus:) body:^{}];
  [factoryDefinition factoryMethod:@selector(wadusWithWadus:andWadus:) body:^{}];

  assertThatInteger(factoryDefinition.countOfFactoryMethods, is(equalToInteger(3)));
}

- (void)test_enumerateFactoryMethods_should_invoke_block_for_no_methods
{
  __block int count = 0;

  [factoryDefinition enumerateFactoryMethods:^(SEL name, id body) {
    count += 1;
  }];

  assertThatInt(count, is(equalToInt(0)));
}

- (void)test_enumerateFactoryMethods_should_invoke_block_for_number_of_factory_methods
{
  [factoryDefinition factoryMethod:@selector(wadus) body:^{}];
  [factoryDefinition factoryMethod:@selector(wadusWithWadus:) body:^{}];
  [factoryDefinition factoryMethod:@selector(wadusWithWadus:andWadus:) body:^{}];
  __block int count = 0;

  [factoryDefinition enumerateFactoryMethods:^(SEL name, id body) {
    count += 1;
  }];

  assertThatInt(count, is(equalToInt(3)));
}

- (void)test_enumerateFactoryMethods_should_invoke_block_with_configured_selector
{
  SEL selector = @selector(wadusWithWadus:andWadus:);
  [factoryDefinition factoryMethod:selector body:^{}];

  [factoryDefinition enumerateFactoryMethods:^(SEL name, id body) {
    assertThat(NSStringFromSelector(name), is(@"wadusWithWadus:andWadus:"));
  }];
}

- (void)test_enumerateFactoryMethods_should_invoke_block_with_configured_body
{
  id (^bodyBlock)(id) = ^id (id factory) {
    return nil;
  };

  [factoryDefinition factoryMethod:@selector(wadus) body:bodyBlock];

  [factoryDefinition enumerateFactoryMethods:^(SEL name, id body) {
    assertThat(body, is(bodyBlock));
  }];
}

@end
