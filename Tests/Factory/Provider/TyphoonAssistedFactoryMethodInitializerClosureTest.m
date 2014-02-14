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
#import "TyphoonAssistedFactoryMethodInitializerClosure.h"
#import "TyphoonAssistedFactoryMethodInitializer.h"

#include <objc/runtime.h>
#include <objc/message.h>


@protocol TyphoonAssistedFactoryMethodInitializerClosureTestProtocol <NSObject>

- (NSString *)stringWithString:(NSString *)string;

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding data:(NSData *)data;

- (NSString *)stringFromProperty;

- (NSString *)stringWithEncoding:(NSStringEncoding)encoding;

@end

@interface TyphoonAssistedFactoryMethodInitializerClosureTest : SenTestCase

@property(nonatomic, copy) NSString *stringProperty;
@property(nonatomic, copy) NSData *dataProperty;

@end

@implementation TyphoonAssistedFactoryMethodInitializerClosureTest

- (void)test_closure_should_invoke_initializer_from_one_parameter {
    TyphoonAssistedFactoryMethodInitializer *initializer =
        [[TyphoonAssistedFactoryMethodInitializer alloc] initWithFactoryMethod:@selector(stringWithString:) returnType:[NSString class]];
    initializer.selector = @selector(initWithString:);
    [initializer injectParameterAtIndex:0 withArgumentAtIndex:0];

    struct objc_method_description methodDescription =
        protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodInitializerClosureTestProtocol), @selector(stringWithString:), YES, YES);
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
    TyphoonAssistedFactoryMethodInitializerClosure
        *closure = [[TyphoonAssistedFactoryMethodInitializerClosure alloc] initWithInitializer:initializer methodSignature:methodSignature];

    NSString *testString = @"test";
    NSInvocation *forwardedInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [forwardedInvocation setArgument:&testString atIndex:2];

    NSInvocation *invocation = [closure invocationWithFactory:nil forwardedInvocation:forwardedInvocation];
    [invocation invoke];

    NSString *result = nil;
    [invocation getReturnValue:&result];
    assertThat(result, equalTo(@"test"));
}

- (void)test_closure_should_invoke_initializer_from_several_parameter {
    TyphoonAssistedFactoryMethodInitializer *initializer = [[TyphoonAssistedFactoryMethodInitializer alloc]
        initWithFactoryMethod:@selector(stringWithEncoding:data:) returnType:[NSString class]];
    initializer.selector = @selector(initWithData:encoding:);
    [initializer injectParameterAtIndex:0 withArgumentAtIndex:1];
    [initializer injectParameterAtIndex:1 withArgumentAtIndex:0];

    struct objc_method_description methodDescription =
        protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodInitializerClosureTestProtocol), @selector(stringWithEncoding:data:), YES, YES);
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
    TyphoonAssistedFactoryMethodInitializerClosure
        *closure = [[TyphoonAssistedFactoryMethodInitializerClosure alloc] initWithInitializer:initializer methodSignature:methodSignature];

    NSStringEncoding encoding = NSUTF8StringEncoding;
    NSData *data = [@"áéíóú" dataUsingEncoding:NSUTF8StringEncoding];

    NSInvocation *forwardedInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [forwardedInvocation setArgument:&encoding atIndex:2];
    [forwardedInvocation setArgument:&data atIndex:3];

    NSInvocation *invocation = [closure invocationWithFactory:nil forwardedInvocation:forwardedInvocation];
    [invocation invoke];

    NSString *result = nil;
    [invocation getReturnValue:&result];
    assertThat(result, equalTo(@"áéíóú"));
}

- (void)test_closure_should_invoke_initializer_from_one_property {
    TyphoonAssistedFactoryMethodInitializer *initializer =
        [[TyphoonAssistedFactoryMethodInitializer alloc] initWithFactoryMethod:@selector(stringFromProperty) returnType:[NSString class]];
    initializer.selector = @selector(initWithString:);
    [initializer injectParameterAtIndex:0 withProperty:@selector(stringProperty)];

    struct objc_method_description methodDescription =
        protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodInitializerClosureTestProtocol), @selector(stringFromProperty), YES, YES);
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
    TyphoonAssistedFactoryMethodInitializerClosure
        *closure = [[TyphoonAssistedFactoryMethodInitializerClosure alloc] initWithInitializer:initializer methodSignature:methodSignature];

    self.stringProperty = @"testing 123";

    NSInvocation *forwardedInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];

    NSInvocation *invocation = [closure invocationWithFactory:self forwardedInvocation:forwardedInvocation];
    [invocation invoke];

    NSString *result = nil;
    [invocation getReturnValue:&result];
    assertThat(result, equalTo(@"testing 123"));
}

- (void)test_closure_should_invoke_initializer_from_mixed_property_and_parameter {
    TyphoonAssistedFactoryMethodInitializer *initializer =
        [[TyphoonAssistedFactoryMethodInitializer alloc] initWithFactoryMethod:@selector(stringWithEncoding:) returnType:[NSString class]];
    initializer.selector = @selector(initWithData:encoding:);
    [initializer injectParameterAtIndex:0 withProperty:@selector(dataProperty)];
    [initializer injectParameterAtIndex:1 withArgumentAtIndex:0];

    struct objc_method_description methodDescription =
        protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodInitializerClosureTestProtocol), @selector(stringWithEncoding:), YES, YES);
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
    TyphoonAssistedFactoryMethodInitializerClosure
        *closure = [[TyphoonAssistedFactoryMethodInitializerClosure alloc] initWithInitializer:initializer methodSignature:methodSignature];

    self.dataProperty = [@"testing 123" dataUsingEncoding:NSASCIIStringEncoding];

    NSStringEncoding encoding = NSUTF8StringEncoding;

    NSInvocation *forwardedInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [forwardedInvocation setArgument:&encoding atIndex:2];

    NSInvocation *invocation = [closure invocationWithFactory:self forwardedInvocation:forwardedInvocation];
    [invocation invoke];

    NSString *result = nil;
    [invocation getReturnValue:&result];
    assertThat(result, equalTo(@"testing 123"));
}

- (void)test_closure_should_fail_if_not_provided_with_enought_parameters {
    TyphoonAssistedFactoryMethodInitializer *initializer =
        [[TyphoonAssistedFactoryMethodInitializer alloc] initWithFactoryMethod:@selector(stringWithEncoding:) returnType:[NSString class]];
    initializer.selector = @selector(initWithData:encoding:);
    [initializer injectParameterAtIndex:0 withProperty:@selector(dataProperty)];
    // Second parameter is missing

    struct objc_method_description methodDescription =
        protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodInitializerClosureTestProtocol), @selector(stringWithEncoding:), YES, YES);
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];

    @try {
        TyphoonAssistedFactoryMethodInitializerClosure *closure =
            [[TyphoonAssistedFactoryMethodInitializerClosure alloc] initWithInitializer:initializer methodSignature:methodSignature];
        STFail(@"[TyphoonAssistedFactoryMethodClosure initWithInitializer:methodDescription:] should have failed");
        closure = nil;
    }
    @catch (NSException *exception) {
        assertThat(exception, isNot(nilValue()));
    }
}


@end
