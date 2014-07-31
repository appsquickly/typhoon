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

////////////////////// TyphoonOptionMatcherValue //////////////////

@interface TyphoonOptionMatch : NSObject
@property (nonatomic, strong) id value;
@property (nonatomic) Class memberClass;
@property (nonatomic) Class kindClass;
@property (nonatomic, strong) TyphoonDefinition *definition;
@property (nonatomic, strong) TyphoonRuntimeArguments *referenceArguments;

+ (id)matchWithValue:(id)value definition:(id)definition;
+ (id)matchWithKindOfClass:(Class)clazz definition:(id)definition;
+ (id)matchWithMemberOfClass:(Class)clazz definition:(id)definition;

@end

@implementation TyphoonOptionMatch

+ (id)matchWithValue:(id)value definition:(id)definition
{
    TyphoonOptionMatch *match = [TyphoonOptionMatch new];
    match.value = value;
    match.definition = definition;
    return match;
}

+ (id)matchWithKindOfClass:(Class)clazz definition:(id)definition
{
    TyphoonOptionMatch *match = [TyphoonOptionMatch new];
    match.kindClass = clazz;
    match.definition = definition;
    return match;
}

+ (id)matchWithMemberOfClass:(Class)clazz definition:(id)definition
{
    TyphoonOptionMatch *match = [TyphoonOptionMatch new];
    match.memberClass = clazz;
    match.definition = definition;
    return match;
}

- (void)setDefinition:(TyphoonDefinition *)definition
{
    _definition = definition;
    self.referenceArguments = definition.currentRuntimeArguments;
}

@end


////////////////////////////////////////

@implementation TyphoonOptionMatcher
{
    NSMutableArray *_matches;
    TyphoonDefinition *_defaultDefinition;
    TyphoonRuntimeArguments *_defaultReferenceArguments;
    BOOL _useMatchingByName;
}

- (instancetype)initWithBlock:(TyphoonMatcherBlock)block
{
    self = [super init];
    if (self) {
        _matches = [NSMutableArray new];
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
    [_matches addObject:[TyphoonOptionMatch matchWithValue:optionValue definition:definition]];
}

- (void)caseKindOfClass:(Class)optionClass use:(id)definition
{
    NSAssert(optionClass, @"optionClass can't be nil");
    NSAssert(definition, @"definition can't be nil");
    [_matches addObject:[TyphoonOptionMatch matchWithKindOfClass:optionClass definition:definition]];
}

- (void)caseMemberOfClass:(Class)optionClass use:(id)definition
{
    NSAssert(optionClass, @"optionClass can't be nil");
    NSAssert(definition, @"definition can't be nil");
    [_matches addObject:[TyphoonOptionMatch matchWithMemberOfClass:optionClass definition:definition]];
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

- (void)findDefinitionMatchedValue:(id)value withFactory:(TyphoonComponentFactory *)factory usingBlock:(TyphoonOptionMatcherDefinitionSearchResult)block
{
    TyphoonDefinition *result = nil;
    TyphoonRuntimeArguments *resultArgs = nil;

    TyphoonOptionMatch *match = [self matchForValue:value];
    if (match) {
        result = match.definition;
        resultArgs = match.referenceArguments;
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


- (TyphoonOptionMatch *)matchForValue:(id)value
{
    for (TyphoonOptionMatch *match in _matches) {
        BOOL isEqual = (match.value && [match.value isEqual:value]);
        BOOL isKind = (match.kindClass && [value isKindOfClass:match.kindClass]);
        BOOL isMember = (match.memberClass && [value isMemberOfClass:match.memberClass]);
        if (isEqual || isKind || isMember) {
            return match;
        }
    }
    return nil;
}


@end