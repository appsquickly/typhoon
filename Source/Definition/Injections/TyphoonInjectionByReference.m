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
        [factory evaluateCircularDependency:self.reference propertyName:self.propertyName instance:instance];
    }

    if (!instance || ![factory isCircularPropertyWithName:self.propertyName onInstance:instance]) {
        return [self componentForReferenceWithFactory:factory args:args];
    }
    return nil;
}

- (void)setArgumentWithType:(TyphoonTypeDescriptor *)type onInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
                       args:(TyphoonRuntimeArguments *)args
{
    [[[factory stack] peekForKey:self.reference] instance]; //Raises circular dependencies exception if already initializing.
    id reference = [self componentForReferenceWithFactory:factory args:args];
    [self setObject:reference forType:type andInvocation:invocation];
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

- (id)componentForReferenceWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)runtimeArgs
{
    TyphoonRuntimeArguments *referenceArgumentsWithRuntime =
        [self argumentsByReplacingRuntimeArgsReferencesInArgs:self.referenceArguments withRuntimeArgs:runtimeArgs];
    return [factory componentForKey:self.reference args:referenceArgumentsWithRuntime];
}

@end
