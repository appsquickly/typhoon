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


#import "TyphoonRuntimeArguments.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonInjections.h"
#import "TyphoonInjectionByReference.h"

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

    for (NSInteger i = 2; i < (NSInteger)count; i++) {
        void *pointer;
        [invocation getArgument:&pointer atIndex:i];
        id argument = (__bridge id) pointer;

        id<TyphoonInjection>injection = TyphoonMakeInjectionFromObjectIfNeeded(argument);
        [self validateRuntimeArgumentWithInjection:injection];
        [args addObject:injection];
    }

    return [[self alloc] initWithArguments:args];
}

+ (void)validateRuntimeArgumentWithInjection:(id)injection
{
    if ([injection isKindOfClass:[TyphoonInjectionByReference class]]) {
        TyphoonInjectionByReference *referenceInjection = injection;
        [referenceInjection.referenceArguments enumerateArgumentsUsingBlock:^(id argument, NSUInteger index, BOOL *stop) {
            if ([argument isKindOfClass:[TyphoonInjectionByRuntimeArgument class]]) {
                [NSException raise:NSInternalInconsistencyException format:@"Congratulations you've tried to do something über-funky with Typhoon %%). You are the 3rd person EVER to receive this error message. Returning a definition that is the result of a nested runtime argument is not supported. Instead unroll the definition."];
            } else {
                [self validateRuntimeArgumentWithInjection:argument];
            }
        }];
    }
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
    return _arguments[index];
}

- (void)enumerateArgumentsUsingBlock:(void(^)(id argument, NSUInteger index, BOOL *stop))block
{
    if (!block) {
        return;
    }

    NSUInteger count = [_arguments count];
    for (NSUInteger i = 0; i < count; ++i) {
        id argument = [self argumentValueAtIndex:i];
        BOOL stop = NO;
        block(argument, i, &stop);
        if (stop) {
            break;
        }
    }
}

- (void)replaceArgumentAtIndex:(NSUInteger)index withArgument:(id)argument
{
    argument = TyphoonMakeInjectionFromObjectIfNeeded(argument);
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
