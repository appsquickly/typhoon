//
//  TyphoonRuntimeArguments.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 10.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonRuntimeArguments.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonInjectionByRuntimeArgument.h"

@interface TyphoonRuntimeNullArgument : NSObject

+ (instancetype)null;

@end

@implementation TyphoonRuntimeNullArgument

+ (instancetype)null
{
    static TyphoonRuntimeNullArgument *sharedNull;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedNull = [TyphoonRuntimeNullArgument new];
    });
    return sharedNull;
}

- (NSUInteger)hash
{
    /** Any constant can be here, nothing magical */
    return 25042013;
}

- (BOOL)isEqual:(id)object
{
    return [object isMemberOfClass:[TyphoonRuntimeNullArgument class]];
}

@end

@implementation TyphoonRuntimeArguments
{
    NSMutableArray *_arguments;
    NSUInteger _hash;
    BOOL _needRehash;
}

+ (instancetype)argumentsFromInvocation:(NSInvocation *)invocation
{
    NSUInteger count = [[invocation methodSignature] numberOfArguments];
    if (count <= 2) {
        return nil;
    }
    NSMutableArray *args = [[NSMutableArray alloc] initWithCapacity:count];

    for (NSUInteger i = 2; i < count; i++) {
        void *pointer;
        [invocation getArgument:&pointer atIndex:i];
        id argument = (__bridge id) pointer;
        if (argument) {
            [args addObject:argument];
        }
        else {
            [args addObject:[TyphoonRuntimeNullArgument null]];
        }
    }

    return [[self alloc] initWithArguments:args];
}

- (id)initWithArguments:(NSMutableArray *)array
{
    self = [super init];
    if (self) {
        _arguments = array;
        _needRehash = YES;
    }
    return self;
}

- (id)argumentValueAtIndex:(NSUInteger)index
{
    id argument = _arguments[index];
    if ([argument isMemberOfClass:[TyphoonRuntimeNullArgument class]]) {
        return nil;
    }
    else {
        return argument;
    }
}

- (void)replaceArgumentAtIndex:(NSUInteger)index withArgument:(id)argument
{
    if (!argument) {
        argument = [TyphoonRuntimeNullArgument null];
    }
    [_arguments replaceObjectAtIndex:index withObject:argument];
    _needRehash = YES;
}

+ (TyphoonRuntimeArguments *)argumentsFromRuntimeArguments:(TyphoonRuntimeArguments *)runtimeArguments appliedToReferenceArguments:(TyphoonRuntimeArguments *)referenceArguments
{
    TyphoonRuntimeArguments *result = referenceArguments;

    Class runtimeArgInjectionClass = [TyphoonInjectionByRuntimeArgument class];
    BOOL hasRuntimeArgumentReferences = [referenceArguments indexOfArgumentWithKind:runtimeArgInjectionClass] != NSNotFound;

    if (referenceArguments && runtimeArguments && hasRuntimeArgumentReferences) {
        result = [referenceArguments copy];
        NSUInteger indexToReplace;
        while ((indexToReplace = [result indexOfArgumentWithKind:runtimeArgInjectionClass]) != NSNotFound) {
            TyphoonInjectionByRuntimeArgument *runtimeArgPlaceholder = [result argumentValueAtIndex:indexToReplace];
            id runtimeValue = [runtimeArguments argumentValueAtIndex:runtimeArgPlaceholder.runtimeArgumentIndex];
            [result replaceArgumentAtIndex:indexToReplace withArgument:runtimeValue];
        }
    }

    return result;
}

- (NSUInteger)indexOfArgumentWithKind:(Class)clazz
{
    return [_arguments indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        BOOL found = NO;
        if ([obj isKindOfClass:clazz]) {
            *stop = YES;
            found = YES;
        }
        return found;
    }];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonRuntimeArguments alloc] initWithArguments:[_arguments mutableCopy]];
}

- (NSUInteger)hash
{
    if (_needRehash) {
        _hash = [self calculateHash];
        _needRehash = NO;
    }
    return _hash;
}

- (NSUInteger)calculateHash
{
    NSUInteger hash = 0;
    
    for (id arg in _arguments) {
        hash = (hash << 5) - hash + [arg hash];
    }
    
    return hash;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"_arguments=%@", _arguments];
    [description appendString:@">"];
    return description;
}

@end
