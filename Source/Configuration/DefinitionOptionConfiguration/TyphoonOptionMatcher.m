//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonDefinition+Option.h"
#import "TyphoonOptionMatcher.h"
#import "TyphoonOptionMatcher+Internal.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "TyphoonDefinition+Infrastructure.h"


@implementation TyphoonOptionMatcher
{
    NSMutableArray *_values;
    NSMutableArray *_definitions;
    NSMutableArray *_referenceArguments;
    TyphoonDefinition *_defaultDefinition;
    TyphoonRuntimeArguments *_defaultReferenceArguments;
    BOOL _useMatchingByName;
}

- (instancetype)initWithBlock:(TyphoonMatcherBlock)block
{
    self = [super init];
    if (self) {
        _values = [NSMutableArray new];
        _definitions = [NSMutableArray new];
        _referenceArguments = [NSMutableArray new];
        _useMatchingByName = NO;

        if (block) {
            block(self);
        }
    }
    return self;
}


- (void)caseOption:(id)optionValue use:(id)definition
{
    NSAssert(optionValue, @"optionValue can't be nil");
    NSAssert(definition, @"definition can't be nil");

    [_values addObject:optionValue];
    [_definitions addObject:definition];

    TyphoonRuntimeArguments *currentRuntimeArgs = ((TyphoonDefinition *) definition).currentRuntimeArguments;
    if (currentRuntimeArgs) {
        [_referenceArguments addObject:currentRuntimeArgs];
    } else {
        [_referenceArguments addObject:[NSNull null]];
    }
}

- (void)useDefinitionWithKeyMatchedOptionValue
{
    _useMatchingByName = YES;
}

- (void)defaultUse:(id)definition
{
    _defaultDefinition = definition;
    _defaultReferenceArguments = ((TyphoonDefinition *)definition).currentRuntimeArguments;
}

- (TyphoonDefinition *)definitionMatchingValue:(id)value withComponentFactory:(TyphoonComponentFactory *)factory
{
    TyphoonDefinition *result = nil;

    NSUInteger index = [_values indexOfObject:value];

    if (index != NSNotFound) {
        result = _definitions[index];
    } else if (_useMatchingByName && [value isKindOfClass:[NSString class]]){
        result = [factory definitionForKey:value];
    }

    if (!result) {
        result = _defaultDefinition;
    }

    if (!result) {
        [NSException raise:NSInternalInconsistencyException format:@"Can't find definition to match value %@",value];
    }

    return result;
}

- (void)findDefinitionMatchedValue:(id)value withFactory:(TyphoonComponentFactory *)factory usingBlock:(TyphoonOptionMatcherDefinitionSearchResult)block
{
    TyphoonDefinition *result = nil;
    TyphoonRuntimeArguments *resultArgs = nil;

    NSUInteger index = [_values indexOfObject:value];

    if (index != NSNotFound) {
        result = _definitions[index];
        resultArgs = _referenceArguments[index];
    } else if (_useMatchingByName && [value isKindOfClass:[NSString class]]){
        result = [factory definitionForKey:value];
    }

    if (!result) {
        result = _defaultDefinition;
        resultArgs = _defaultReferenceArguments;
    }

    if (!result) {
        [NSException raise:NSInternalInconsistencyException format:@"Can't find definition to match value %@",value];
    }

    if ([resultArgs isKindOfClass:[NSNull class]]) {
        resultArgs = nil;
    }

    block(result, resultArgs);
}



@end