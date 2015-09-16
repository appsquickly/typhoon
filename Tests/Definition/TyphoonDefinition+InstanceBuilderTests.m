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
#import "TyphoonInjections.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByObjectFromString.h"
#import "TyphoonDefinition+Tests.h"
#import "OCLogTemplate.h"

@interface TyphoonDefinitionInstanceBuilderTests : XCTestCase

@end

@implementation TyphoonDefinitionInstanceBuilderTests

- (void)test_injections_enumerator
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[NSObject class]];
    [definition injectProperty:@selector(propertyA) with:@"A"];
    [definition injectProperty:@selector(propertyB) with:@"B"];
    [definition injectProperty:@selector(propertyC) with:@"C"];
    [definition injectProperty:@selector(propertyString) with:TyphoonInjectionWithObjectFromString(@"string")];
    [definition useInitializer:@selector(initWithD:E:F:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:@"D"];
        [initializer injectParameterWith:@"E"];
        [initializer injectParameterWith:@"F"];
    }];

    __block NSUInteger injectionsCount = 0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByObjectInstance class] options:TyphoonInjectionsEnumerationOptionAll
                               usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
#pragma clang diagnostic pop
        injectionsCount++;
    }];

    XCTAssertTrue(injectionsCount == 6);

    injectionsCount = 0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByObjectFromString class] options:TyphoonInjectionsEnumerationOptionAll
                               usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
#pragma clang diagnostic pop
        injectionsCount++;
    }];
    XCTAssertTrue(injectionsCount == 1);
}

- (void)test_injections_replacement
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[NSObject class]];
    [definition injectProperty:@selector(propertyA) with:@"A"];
    [definition injectProperty:@selector(propertyB) with:TyphoonInjectionWithObjectFromString(@"B")];
    [definition injectProperty:@selector(propertyC) with:@"C"];
    [definition injectProperty:@selector(propertyString) with:TyphoonInjectionWithObjectFromString(@"string")];
    [definition useInitializer:@selector(initWithD:E:F:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:@"D"];
        [initializer injectParameterWith:@"E"];
        [initializer injectParameterWith:@"F"];
    }];

    __block NSUInteger injectionsCount = 0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByObjectFromString class] options:TyphoonInjectionsEnumerationOptionAll
                               usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
#pragma clang diagnostic pop
        injectionsCount++;
        *injectionToReplace = TyphoonInjectionWithObject(@"B");
    }];

    XCTAssertTrue(injectionsCount == 2);

    injectionsCount = 0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByObjectFromString class] options:TyphoonInjectionsEnumerationOptionAll
                               usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
#pragma clang diagnostic pop
        injectionsCount++;
    }];

    XCTAssertTrue(injectionsCount == 0);
}

- (void)test_property_injection_replacement_with_parent
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[NSObject class]];
    [parent injectProperty:@selector(propertyA) with:@"A"];
    [parent injectProperty:@selector(propertyB) with:@"B"];

    TyphoonDefinition *child = [TyphoonDefinition withClass:[NSObject class]];
    child.parent = parent;
    [child injectProperty:@selector(propertyA) with:@"C"];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
    [child enumerateInjectionsOfKind:[TyphoonInjectionByObjectInstance class] options:TyphoonInjectionsEnumerationOptionAll
                          usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
#pragma clang diagnostic pop
        *injectionToReplace = TyphoonInjectionWithObjectFromString(@"B");
    }];

    XCTAssertEqual([parent numberOfPropertyInjectionsByObjectFromString], (NSUInteger)1);
    LogInfo(@"child: %@",child.injectedProperties);
    XCTAssertEqual([child numberOfPropertyInjectionsByObjectFromString], (NSUInteger)2);
}

- (void)test_method_injection_replacement_with_parent
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[NSObject class]];
    [parent injectMethod:@selector(setA:) parameters:^(TyphoonMethod *method) {
        [method injectParameterWith:@"A"];
    }];
    [parent injectMethod:@selector(setB:) parameters:^(TyphoonMethod *method) {
        [method injectParameterWith:@"B"];
    }];

    TyphoonDefinition *child = [TyphoonDefinition withClass:[NSObject class]];
    child.parent = parent;
    [child injectMethod:@selector(setA:) parameters:^(TyphoonMethod *method) {
        [method injectParameterWith:@"C"];
    }];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
    [child enumerateInjectionsOfKind:[TyphoonInjectionByObjectInstance class] options:TyphoonInjectionsEnumerationOptionAll
                          usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
#pragma clang diagnostic pop
        *injectionToReplace = TyphoonInjectionWithObjectFromString(@"B");
    }];

    XCTAssertEqual([parent numberOfMethodInjectionsByObjectFromString], (NSUInteger)1);
    XCTAssertEqual([child numberOfMethodInjectionsByObjectFromString], (NSUInteger)2);
}

@end
