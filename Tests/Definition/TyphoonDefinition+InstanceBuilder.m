//
//  TyphoonDefinition+InstanceBuilder.m
//  Typhoon
//
//  Created by Aleksey Garbarev on 22.05.14.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonInjections.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByObjectFromString.h"

@interface TyphoonDefinitionInstanceBuilderTests : SenTestCase

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
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByObjectInstance class] options:TyphoonInjectionsEnumerationOptionAll
                               usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
        injectionsCount++;
    }];

    STAssertTrue(injectionsCount == 6, nil);

    injectionsCount = 0;
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByObjectFromString class] options:TyphoonInjectionsEnumerationOptionAll
                               usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
        injectionsCount++;
    }];
    STAssertTrue(injectionsCount == 1, nil);
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
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByObjectFromString class] options:TyphoonInjectionsEnumerationOptionAll
                               usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
        injectionsCount++;
        *injectionToReplace = TyphoonInjectionWithObject(@"B");
    }];

    STAssertTrue(injectionsCount == 2, nil);

    injectionsCount = 0;
    [definition enumerateInjectionsOfKind:[TyphoonInjectionByObjectFromString class] options:TyphoonInjectionsEnumerationOptionAll
                               usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
        injectionsCount++;
    }];

    STAssertTrue(injectionsCount == 0, nil);
}

- (void)test_property_injection_replacement_with_parent
{
    TyphoonDefinition *parent = [TyphoonDefinition withClass:[NSObject class]];
    [parent injectProperty:@selector(propertyA) with:@"A"];
    [parent injectProperty:@selector(propertyB) with:@"B"];

    TyphoonDefinition *child = [TyphoonDefinition withClass:[NSObject class]];
    child.parent = parent;
    [child injectProperty:@selector(propertyA) with:@"C"];

    [child enumerateInjectionsOfKind:[TyphoonInjectionByObjectInstance class] options:TyphoonInjectionsEnumerationOptionAll
                          usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
        *injectionToReplace = TyphoonInjectionWithObjectFromString(@"B");
    }];

    STAssertEquals([parent numberOfPropertyInjectionsByObjectFromString], (NSUInteger)1, nil);
    NSLog(@"child: %@",child.injectedProperties);
    STAssertEquals([child numberOfPropertyInjectionsByObjectFromString], (NSUInteger)2, nil);
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

    [child enumerateInjectionsOfKind:[TyphoonInjectionByObjectInstance class] options:TyphoonInjectionsEnumerationOptionAll
                          usingBlock:^(id <TyphoonInjection> injection, id <TyphoonInjection> *injectionToReplace, BOOL *stop) {
        *injectionToReplace = TyphoonInjectionWithObjectFromString(@"B");
    }];

    STAssertEquals([parent numberOfMethodInjectionsByObjectFromString], (NSUInteger)1, nil);
    STAssertEquals([child numberOfMethodInjectionsByObjectFromString], (NSUInteger)2, nil);
}

@end
