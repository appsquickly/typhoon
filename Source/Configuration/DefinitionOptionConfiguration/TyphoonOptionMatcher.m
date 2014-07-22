//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonDefinition+Option.h"
#import "TyphoonOptionMatcher.h"
#import "TyphoonOptionMatcher+Internal.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"


@implementation TyphoonOptionMatcher
{
    NSMutableArray *_values;
    NSMutableArray *_definitions;
    BOOL _useMatchingByName;
    TyphoonDefinition *_defaultDefinition;
}

- (instancetype)initWithBlock:(TyphoonMatcherBlock)block
{
    self = [super init];
    if (self) {
        _values = [NSMutableArray new];
        _definitions = [NSMutableArray new];
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
}

- (void)useDefinitionWithKeyMatchedOptionValue
{
    _useMatchingByName = YES;
}

- (void)defaultUse:(id)definition
{
    _defaultDefinition = definition;
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

@end