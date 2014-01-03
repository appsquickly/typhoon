//
// Created by Robert Gilliam on 11/18/13.
//


#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import <Typhoon/TyphoonInitializer.h>
#import "TyphoonFakeLogger.h"


@interface TyphoonInitializerTests : SenTestCase
@end


@implementation TyphoonInitializerTests
{
    TyphoonFakeLogger* logger;
    TyphoonInitializer *initializer;
}

- (void)setUp
{
    [super setUp];

    logger = [[TyphoonFakeLogger alloc] initWithTestCase:self];
}

- (void)test_single_parameter_method_incorrect_parameter_name_warns
{
    initializer = [self newInitializerWithSelector:@selector(initWithString:)];
    [initializer injectParameterNamed:@"strnig" withObject:@"a string"];

    [logger shouldHaveLogged:@"Unrecognized parameter name: 'strnig' for method 'initWithString:'. Did you mean 'string'?"];
}

- (void)test_two_parameter_method_incorrect_parameter_name_warns
{
    initializer = [self newInitializerWithSelector:@selector(initWithClass:key:)];
    [initializer injectParameterNamed:@"keyy" withObject:@"a key"];

    [logger shouldHaveLogged:@"Unrecognized parameter name: 'keyy' for method 'initWithClass:key:'. Valid parameter names are 'class' or 'key'."];
}

- (void)test_multiple_parameter_method_incorrect_parameter_name_warns
{
    initializer = [self newInitializerWithSelector:@selector(initWithContentsOfURL:options:error:)];
    [initializer injectParameterNamed:@"path" withObject:@"a parameter that isn't there"];

    [logger shouldHaveLogged:@"Unrecognized parameter name: 'path' for method 'initWithContentsOfURL:options:error:'. Valid parameter names are 'contentsOfURL', 'options', or 'error'."];
}

- (void)test_no_parameter_method_parameter_name_specified
{
    initializer = [self newInitializerWithSelector:@selector(init)];
    [initializer injectParameterNamed:@"aParameter" withObject:@"anObject"];

    [logger shouldHaveLogged:@"Specified a parameter named 'aParameter', but method 'init' takes no parameters."];
}

- (TyphoonInitializer*)newInitializerWithSelector:(SEL)aSelector
{
    TyphoonInitializer* anInitializer = [[TyphoonInitializer alloc] initWithSelector:aSelector];
    anInitializer.logger = logger;
    return anInitializer;
}

@end