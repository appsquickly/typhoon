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
#import "TyphoonAssistedFactoryMethodClosure.h"
#import "TyphoonAssistedFactoryMethodInitializer.h"

#include <objc/runtime.h>
#include <objc/message.h>


@protocol TyphoonAssistedFactoryMethodClosureTestProtocol <NSObject>

- (NSString *)stringWithString:(NSString *)string;

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding data:(NSData *)data;

- (NSString *)stringFromProperty;

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding;

@end

@interface TyphoonAssistedFactoryMethodClosureTest : SenTestCase

@property (nonatomic, copy) NSString *stringProperty;
@property (nonatomic, copy) NSData *dataProperty;

@end

@implementation TyphoonAssistedFactoryMethodClosureTest

- (void)test_closure_should_invoke_initializer_from_one_parameter
{
    TyphoonAssistedFactoryMethodInitializer *initializer = [[TyphoonAssistedFactoryMethodInitializer alloc]
                                                            initWithFactoryMethod:@selector(stringWithString:)
                                                            returnType:[NSString class]];
    initializer.selector = @selector(initWithString:);
    [initializer injectParameterAtIndex:0 withArgumentAtIndex:0];

    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodClosureTestProtocol),
                                                                                     @selector(stringWithString:),
                                                                                     YES, YES);
    TyphoonAssistedFactoryMethodClosure *closure = [[TyphoonAssistedFactoryMethodClosure alloc]
                                                    initWithInitializer:initializer
                                                    methodDescription:methodDescription];

    id (*fn)(id, SEL, NSString *) = (id (*)(id, SEL, NSString *))[closure fptr];
    NSString *result = fn(self, @selector(stringWithString:), @"test");
    assertThat(result, equalTo(@"test"));
}

- (void)test_closure_should_invoke_initializer_from_several_parameter
{
    TyphoonAssistedFactoryMethodInitializer *initializer = [[TyphoonAssistedFactoryMethodInitializer alloc]
                                                            initWithFactoryMethod:@selector(stringWithEncoding:data:)
                                                            returnType:[NSString class]];
    initializer.selector = @selector(initWithData:encoding:);
    [initializer injectParameterAtIndex:0 withArgumentAtIndex:1];
    [initializer injectParameterAtIndex:1 withArgumentAtIndex:0];

    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodClosureTestProtocol),
                                                                                     @selector(stringWithEncoding:data:),
                                                                                     YES, YES);
    TyphoonAssistedFactoryMethodClosure *closure = [[TyphoonAssistedFactoryMethodClosure alloc]
                                                    initWithInitializer:initializer
                                                    methodDescription:methodDescription];

    id (*fn)(id, SEL, NSStringEncoding, NSData *) = (id (*)(id, SEL, NSStringEncoding, NSData *))[closure fptr];
    NSData *data = [@"áéíóú" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *result = fn(self, @selector(stringWithEncoding:data:), NSUTF8StringEncoding, data);
    assertThat(result, equalTo(@"áéíóú"));
}

- (void)test_closure_should_invoke_initializer_from_one_property
{
    TyphoonAssistedFactoryMethodInitializer *initializer = [[TyphoonAssistedFactoryMethodInitializer alloc]
                                                            initWithFactoryMethod:@selector(stringFromProperty)
                                                            returnType:[NSString class]];
    initializer.selector = @selector(initWithString:);
    [initializer injectParameterAtIndex:0 withProperty:@selector(stringProperty)];

    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodClosureTestProtocol),
                                                                                     @selector(stringFromProperty),
                                                                                     YES, YES);
    TyphoonAssistedFactoryMethodClosure *closure = [[TyphoonAssistedFactoryMethodClosure alloc]
                                                    initWithInitializer:initializer
                                                    methodDescription:methodDescription];

    id (*fn)(id, SEL) = (id (*)(id, SEL))[closure fptr];
    self.stringProperty = @"testing 123";
    NSString *result = fn(self, @selector(stringFromProperty));
    assertThat(result, equalTo(@"testing 123"));
}

- (void)test_closure_should_invoke_initializer_from_mixed_property_and_parameter
{
    TyphoonAssistedFactoryMethodInitializer *initializer = [[TyphoonAssistedFactoryMethodInitializer alloc]
                                                            initWithFactoryMethod:@selector(stringWithEncoding:)
                                                            returnType:[NSString class]];
    initializer.selector = @selector(initWithData:encoding:);
    [initializer injectParameterAtIndex:0 withProperty:@selector(dataProperty)];
    [initializer injectParameterAtIndex:1 withArgumentAtIndex:0];

    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodClosureTestProtocol),
                                                                                     @selector(stringWithEncoding:),
                                                                                     YES, YES);
    TyphoonAssistedFactoryMethodClosure *closure = [[TyphoonAssistedFactoryMethodClosure alloc]
                                                    initWithInitializer:initializer
                                                    methodDescription:methodDescription];

    id (*fn)(id, SEL, NSStringEncoding) = (id (*)(id, SEL, NSStringEncoding))[closure fptr];
    self.dataProperty = [@"testing 123" dataUsingEncoding:NSASCIIStringEncoding];
    NSString *result = fn(self, @selector(stringWithEncoding:), NSASCIIStringEncoding);
    assertThat(result, equalTo(@"testing 123"));
}

- (void)test_closure_should_fail_if_not_provided_with_enought_parameters
{
    TyphoonAssistedFactoryMethodInitializer *initializer = [[TyphoonAssistedFactoryMethodInitializer alloc]
                                                            initWithFactoryMethod:@selector(stringWithEncoding:)
                                                            returnType:[NSString class]];
    initializer.selector = @selector(initWithData:encoding:);
    [initializer injectParameterAtIndex:0 withProperty:@selector(dataProperty)];
    // Second parameter is missing

    struct objc_method_description methodDescription = protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodClosureTestProtocol),
                                                                                     @selector(stringWithEncoding:),
                                                                                     YES, YES);

    @try {
        TyphoonAssistedFactoryMethodClosure *closure = [[TyphoonAssistedFactoryMethodClosure alloc]
                                                        initWithInitializer:initializer
                                                        methodDescription:methodDescription];
        STFail(@"[TyphoonAssistedFactoryMethodClosure initWithInitializer:methodDescription:] should have failed");
        closure = nil;
    }
    @catch (NSException *exception) {
        assertThat(exception, isNot(nilValue()));
    }
}


@end
