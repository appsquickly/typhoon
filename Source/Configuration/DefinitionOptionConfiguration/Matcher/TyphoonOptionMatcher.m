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

#import "TyphoonDefinition+Option.h"
#import "TyphoonInjections.h"
#import "TyphoonInjection.h"

////////////////////// TyphoonOptionMatcherValue //////////////////

@interface TyphoonOptionMatchNilValue : NSObject
@end
@implementation TyphoonOptionMatchNilValue
@end

@interface TyphoonOptionMatch : NSObject
@property (nonatomic, strong) id value;
@property (nonatomic) Class memberClass;
@property (nonatomic) Class kindClass;
@property (nonatomic) Protocol *conformProtocol;
@property (nonatomic, strong) id<TyphoonInjection> injection;

+ (id)matchWithValue:(id)value injection:(id)injection;
+ (id)matchWithKindOfClass:(Class)clazz injection:(id)injection;
+ (id)matchWithMemberOfClass:(Class)clazz injection:(id)injection;
+ (id)matchWithConformsToProtocol:(Protocol *)conformProtocol injection:(id)injection;

@end

@implementation TyphoonOptionMatch

+ (id)matchWithValue:(id)value injection:(id)injection
{
    TyphoonOptionMatch *match = [TyphoonOptionMatch new];
    if (value) {
        match.value = value;
    } else {
        match.value = [TyphoonOptionMatchNilValue class];
    }
    match.injection = TyphoonMakeInjectionFromObjectIfNeeded(injection);
    return match;
}

+ (id)matchWithKindOfClass:(Class)clazz injection:(id)injection
{
    TyphoonOptionMatch *match = [TyphoonOptionMatch new];
    match.kindClass = clazz;
    match.injection = TyphoonMakeInjectionFromObjectIfNeeded(injection);
    return match;
}

+ (id)matchWithMemberOfClass:(Class)clazz injection:(id)injection
{
    TyphoonOptionMatch *match = [TyphoonOptionMatch new];
    match.memberClass = clazz;
    match.injection = TyphoonMakeInjectionFromObjectIfNeeded(injection);
    return match;
}

+ (id)matchWithConformsToProtocol:(Protocol *)conformProtocol injection:(id)injection
{
    TyphoonOptionMatch *match = [TyphoonOptionMatch new];
    match.conformProtocol = conformProtocol;
    match.injection = TyphoonMakeInjectionFromObjectIfNeeded(injection);
    return match;
}

@end


////////////////////////////////////////

@implementation TyphoonOptionMatcher
{
    NSMutableArray *_matches;
    id<TyphoonInjection> _defaultInjection;
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

- (void)caseEqual:(id)optionValue use:(id)injection
{
    [_matches addObject:[TyphoonOptionMatch matchWithValue:optionValue injection:injection]];
}

- (void)caseKindOfClass:(Class)optionClass use:(id)injection
{
    [_matches addObject:[TyphoonOptionMatch matchWithKindOfClass:optionClass injection:injection]];
}

- (void)caseMemberOfClass:(Class)optionClass use:(id)injection
{
    [_matches addObject:[TyphoonOptionMatch matchWithMemberOfClass:optionClass injection:injection]];
}

- (void)caseConformsToProtocol:(Protocol *)optionProtocol use:(id)injection
{
    [_matches addObject:[TyphoonOptionMatch matchWithConformsToProtocol:optionProtocol injection:injection]];
}

- (void)useDefinitionWithKeyMatchedOptionValue
{
    _useMatchingByName = YES;
}

- (void)defaultUse:(id)injection
{
    _defaultInjection = TyphoonMakeInjectionFromObjectIfNeeded(injection);
}

- (id<TyphoonInjection>)injectionMatchedValue:(id)value
{
    id<TyphoonInjection> injection = nil;

    TyphoonOptionMatch *match = [self matchForValue:value];
    if (match) {
        injection = match.injection;
    } else if (_useMatchingByName && [value isKindOfClass:[NSString class]]){
        injection = TyphoonInjectionWithReference(value);
    }

    if (!injection) {
        injection = _defaultInjection;
    }

    if (!injection) {
        [NSException raise:NSInternalInconsistencyException format:@"Can't find injection to match value %@",value];
    }

    return injection;
}

- (TyphoonOptionMatch *)matchForValue:(id)value
{
    for (TyphoonOptionMatch *match in _matches) {
        BOOL isEqual = (match.value && [match.value isEqual:value]) || ([match.value isEqual:[TyphoonOptionMatchNilValue class]] && !value);
        BOOL isKind = (match.kindClass && [value isKindOfClass:match.kindClass]);
        BOOL isMember = (match.memberClass && [value isMemberOfClass:match.memberClass]);
        BOOL doesConform = (match.conformProtocol && [value conformsToProtocol:match.conformProtocol]);
        if (isEqual || isKind || isMember || doesConform) {
            return match;
        }
    }
    return nil;
}


@end
