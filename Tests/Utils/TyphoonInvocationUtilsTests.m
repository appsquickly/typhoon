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
#import "TyphoonInvocationUtilsTestObjects.h"
#import "NSInvocation+TCFInstanceBuilder.h"
#import <objc/message.h>

#define retainCount(a) ((int)objc_msgSend(a, NSSelectorFromString(@"retainCount")))

@interface TyphoonInvocationUtilsTests : SenTestCase

@end

@implementation TyphoonInvocationUtilsTests

+ (NSInvocation*)invocationForInstanceSelector:(SEL)selector class:(Class)class
{
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[class instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    return invocation;
}

+ (NSInvocation*)invocationForClassSelector:(SEL)selector class:(Class)class
{
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[class methodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    return invocation;
}


- (void)test_regular_object
{
    Class clazz = [ObjectInitRetained class];
    NSInvocation* invocation = [TyphoonInvocationUtilsTests invocationForInstanceSelector:@selector(init) class:clazz];

    ObjectInitRetained* object = [invocation typhoon_resultOfInvokingOnAllocationForClass:clazz];

    assertThatInt(retainCount(object), equalToInt(1));
}

- (void)test_object_new_retained
{
    Class clazz = [ObjectNewRetained class];
    NSInvocation* invocation = [TyphoonInvocationUtilsTests invocationForClassSelector:@selector(newObject) class:clazz];

    ObjectInitRetained* object = [invocation typhoon_resultOfInvokingOnInstance:clazz];

    assertThatInt(retainCount(object), equalToInt(1));
}

- (void)test_object_new_autorelease
{
    Class clazz = [ObjectNewAutorelease class];
    NSInvocation* invocation = [TyphoonInvocationUtilsTests invocationForClassSelector:@selector(object) class:clazz];

    ObjectInitRetained* object = [invocation typhoon_resultOfInvokingOnInstance:clazz];

    assertThatInt(retainCount(object), equalToInt(1));
}

- (void)test_cluster_release
{
    Class clazz = [ObjectInitCluster class];
    NSInvocation* invocation = [TyphoonInvocationUtilsTests invocationForInstanceSelector:@selector(initOldRelease) class:clazz];

    ObjectInitRetained* object = [invocation typhoon_resultOfInvokingOnAllocationForClass:clazz];

    assertThatInt(retainCount(object), equalToInt(1));
}

- (void)test_cluster_autorelease
{
    Class clazz = [ObjectInitCluster class];
    NSInvocation* invocation = [TyphoonInvocationUtilsTests invocationForInstanceSelector:@selector(initOldAutorelease) class:clazz];

    ObjectInitRetained* object = [invocation typhoon_resultOfInvokingOnAllocationForClass:clazz];

    assertThatInt(retainCount(object), equalToInt(1));
}

- (void)test_cluster_nil
{
    Class clazz = [ObjectInitCluster class];
    NSInvocation* invocation = [TyphoonInvocationUtilsTests invocationForInstanceSelector:@selector(initReturnNil) class:clazz];

    ObjectInitRetained* object = [invocation typhoon_resultOfInvokingOnAllocationForClass:clazz];

    assertThat(object, is(nilValue()));
}

@end
