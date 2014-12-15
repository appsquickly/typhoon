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


#import "TyphoonInjectionByReference.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonCallStack.h"
#import "TyphoonStackElement.h"
#import "NSInvocation+TCFUnwrapValues.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonUtils.h"

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

- (BOOL)isEqualToCustom:(TyphoonInjectionByReference *)injection
{
    return [self.reference isEqual:injection.reference] && [self.referenceArguments isEqual:injection.referenceArguments];
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

#pragma mark - Protected

- (void)resolveCircularDependencyWithContext:(TyphoonInjectionContext *)context block:(dispatch_block_t)block
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsFromRuntimeArguments:context.args appliedToReferenceArguments:_referenceArguments];
    [context.factory resolveCircularDependency:self.reference args:args resolvedBlock:^(BOOL isCircular) {
        block();
    }];
}

//Raises circular dependencies exception if already initializing.
- (id)resolveReferenceWithContext:(TyphoonInjectionContext *)context
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsFromRuntimeArguments:context.args appliedToReferenceArguments:_referenceArguments];
    
    id referenceInstance = [[[context.factory stack] peekForKey:self.reference args:args] instance];
    if (!referenceInstance) {
        referenceInstance = [context.factory componentForKey:self.reference args:args];
    }
    return referenceInstance;
}

- (NSUInteger)customHash
{
    return TyphoonHashByAppendingInteger([_reference hash], [_referenceArguments hash]);
}

@end
