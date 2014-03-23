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
    [self copyBaseProperiesTo:copied];
    return copied;
}

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    if (instance) {
        [factory evaluateCircularDependency:self.reference propertyName:self.propertyName instance:instance args:args];
        if ([factory isCircularPropertyWithName:self.propertyName onInstance:instance]) {
            return nil;
        }
    }
    
    return [self componentForReferenceWithFactory:factory args:args];
}

- (void)setArgumentWithType:(TyphoonTypeDescriptor *)type onInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
                       args:(TyphoonRuntimeArguments *)args
{
    id referenceInstance = [self componentForReferenceWithFactory:factory args:args];
    [invocation typhoon_setArgumentObject:referenceInstance atIndex:self.parameterIndex + 2];
}

#pragma mark - Utils

- (TyphoonRuntimeArguments *)argumentsByReplacingRuntimeArgsReferencesInArgs:(TyphoonRuntimeArguments *)referenceArgs
    withRuntimeArgs:(TyphoonRuntimeArguments *)runtimeArgs
{
    TyphoonRuntimeArguments *result = referenceArgs;

    Class runtimeArgInjectionClass = [TyphoonInjectionByRuntimeArgument class];
    BOOL hasRuntimeArgumentReferences = [referenceArgs indexOfArgumentWithKind:runtimeArgInjectionClass] != NSNotFound;

    if (referenceArgs && runtimeArgs && hasRuntimeArgumentReferences) {
        result = [referenceArgs copy];
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

//Raises circular dependencies exception if already initializing.
- (id)componentForReferenceWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)runtimeArgs
{
    id referenceInstance = [[[factory stack] peekForKey:self.reference args:runtimeArgs] instance];
    if (!referenceInstance) {
        TyphoonRuntimeArguments *referenceArgumentsWithRuntime =
        [self argumentsByReplacingRuntimeArgsReferencesInArgs:self.referenceArguments withRuntimeArgs:runtimeArgs];
        referenceInstance = [factory componentForKey:self.reference args:referenceArgumentsWithRuntime];
    }
    return referenceInstance;
}

@end
