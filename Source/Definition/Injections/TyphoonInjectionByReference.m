//
//  TyphoonInjectionByReference.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 11.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByReference.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonCallStack.h"
#import "TyphoonStackElement.h"
#import "NSInvocation+TCFUnwrapValues.h"
#import "TyphoonDefinition+InstanceBuilder.h"

@implementation TyphoonInjectionByReference

- (instancetype)initWithReference:(NSString *)reference args:(TyphoonRuntimeArguments *)referenceArguments
{
    self = [super init];
    if (self) {
        _reference = reference;
        _referenceArguments = referenceArguments;
    }
    return self;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByReference *copied = [[TyphoonInjectionByReference alloc] initWithReference:_reference args:_referenceArguments];
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    if (context.raiseExceptionIfCircular) {
        result([self resolveReferenceWithContext:context]);
    } else {
        [self resolveCircularDependencyWithContext:context block:^{
            result([self resolveReferenceWithContext:context]);
        }];
    }
}

#pragma mark - Utils

- (TyphoonRuntimeArguments *)referenceArgumentsByApplyingRuntimeArgs:(TyphoonRuntimeArguments *)runtimeArgs
{
    TyphoonRuntimeArguments *result = _referenceArguments;

    Class runtimeArgInjectionClass = [TyphoonInjectionByRuntimeArgument class];
    BOOL hasRuntimeArgumentReferences = [_referenceArguments indexOfArgumentWithKind:runtimeArgInjectionClass] != NSNotFound;

    if (_referenceArguments && runtimeArgs && hasRuntimeArgumentReferences) {
        result = [_referenceArguments copy];
        NSUInteger indexToReplace;
        while ((indexToReplace = [result indexOfArgumentWithKind:runtimeArgInjectionClass]) != NSNotFound) {
            TyphoonInjectionByRuntimeArgument *runtimeArgPlaceholder = [result argumentValueAtIndex:indexToReplace];
            id runtimeValue = [runtimeArgs argumentValueAtIndex:runtimeArgPlaceholder.runtimeArgumentIndex];
            [result replaceArgumentAtIndex:indexToReplace withArgument:runtimeValue];
        }
    }

    return result;
}

#pragma mark - Protected

- (void)resolveCircularDependencyWithContext:(TyphoonInjectionContext *)context block:(dispatch_block_t)block
{
    TyphoonRuntimeArguments *args = [self referenceArgumentsByApplyingRuntimeArgs:context.args];
    [context.factory resolveCircularDependency:self.reference args:args resolvedBlock:^(BOOL isCircular) {
        block();
    }];
}

//Raises circular dependencies exception if already initializing.
- (id)resolveReferenceWithContext:(TyphoonInjectionContext *)context
{
    TyphoonRuntimeArguments *args = [self referenceArgumentsByApplyingRuntimeArgs:context.args];
    
    id referenceInstance = [[[context.factory stack] peekForKey:self.reference args:args] instance];
    if (!referenceInstance) {
        referenceInstance = [context.factory componentForKey:self.reference args:args];
    }
    return referenceInstance;
}

@end
