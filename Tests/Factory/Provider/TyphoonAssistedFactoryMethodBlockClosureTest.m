////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <XCTest/XCTest.h>
#import "TyphoonAssistedFactoryMethodBlockClosure.h"

#include <objc/runtime.h>
#include <objc/message.h>


@protocol TyphoonAssistedFactoryMethodBlockClosureTestProtocol <NSObject>

- (NSString *)originalFactoryMethodWithParameter1:(NSString *)string parameter2:(NSUInteger)number;

// Tecnically this will not be in the protocol, but for testing pourposes is good enough.
- (NSString *)typhoon_interceptable_originalFactoryMethodWithParameter1:(NSString *)string parameter2:(NSUInteger)number;

@end

@interface TyphoonAssistedFactoryMethodBlockClosureTest : XCTestCase

@end

@implementation TyphoonAssistedFactoryMethodBlockClosureTest
{
    NSMethodSignature *methodSignature;
    NSInvocation *forwardedInvocation;

    NSString *testString;
    NSUInteger testNumber;
}

- (void)setUp
{
    struct objc_method_description methodDescription =
        protocol_getMethodDescription(@protocol(TyphoonAssistedFactoryMethodBlockClosureTestProtocol), @selector(originalFactoryMethodWithParameter1:parameter2:), YES, YES);
    methodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];

    testString = @"test";
    testNumber = 123;
    forwardedInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [forwardedInvocation setArgument:&testString atIndex:2];
    [forwardedInvocation setArgument:&testNumber atIndex:3];
}

- (void)test_closure_should_fill_invocation_with_given_factory
{
    TyphoonAssistedFactoryMethodBlockClosure *closure = [[TyphoonAssistedFactoryMethodBlockClosure alloc]
        initWithSelector:@selector(typhoon_interceptable_originalFactoryMethodWithParameter1:parameter2:) methodSignature:methodSignature];


    id factory = mockProtocol(@protocol(TyphoonAssistedFactoryMethodBlockClosureTestProtocol));
    NSInvocation *invocation = [closure invocationWithFactory:factory forwardedInvocation:forwardedInvocation];

    assertThat(invocation.target, equalTo(factory));
}

- (void)test_closure_should_fill_invocation_with_given_selector
{
    TyphoonAssistedFactoryMethodBlockClosure *closure = [[TyphoonAssistedFactoryMethodBlockClosure alloc]
        initWithSelector:@selector(typhoon_interceptable_originalFactoryMethodWithParameter1:parameter2:) methodSignature:methodSignature];


    id factory = mockProtocol(@protocol(TyphoonAssistedFactoryMethodBlockClosureTestProtocol));
    NSInvocation *invocation = [closure invocationWithFactory:factory forwardedInvocation:forwardedInvocation];

    assertThatBool(invocation.selector ==
        @selector(typhoon_interceptable_originalFactoryMethodWithParameter1:parameter2:), equalToBool(YES));
}

- (void)test_closure_should_copy_arguments_directly
{
    TyphoonAssistedFactoryMethodBlockClosure *closure = [[TyphoonAssistedFactoryMethodBlockClosure alloc]
        initWithSelector:@selector(typhoon_interceptable_originalFactoryMethodWithParameter1:parameter2:) methodSignature:methodSignature];


    id factory = mockProtocol(@protocol(TyphoonAssistedFactoryMethodBlockClosureTestProtocol));
    NSInvocation *invocation = [closure invocationWithFactory:factory forwardedInvocation:forwardedInvocation];

    NSString *aString;
    [invocation getArgument:&aString atIndex:2];
    assertThat(aString, equalTo(testString));

    NSUInteger aNumber;
    [invocation getArgument:&aNumber atIndex:3];
    assertThatUnsignedInteger(aNumber, equalToUnsignedInteger(testNumber));
}

@end
