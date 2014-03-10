////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonPropertyInjectedByReference.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonPropertyInjectedWithRuntimeArg.h"

@implementation TyphoonPropertyInjectedByReference

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (instancetype)initWithName:(NSString *)name reference:(NSString *)reference
{
    self = [super init];
    if (self) {
        _name = name;
        _reference = reference;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (id)withFactory:(TyphoonComponentFactory *)factory computeValueToInjectOnInstance:(id)instance args:(TyphoonRuntimeArguments *)args
{
    [factory evaluateCircularDependency:self.reference propertyName:self.name instance:instance];

    [self replaceArgsReferencesInBuildArgs:self.assemblyBuildArgs withRuntimeArgs:args];
    
    if (![factory propertyIsCircular:self onInstance:instance]) {
        return [factory componentForKey:self.reference args:self.assemblyBuildArgs];
    }
    return nil;
}

- (void) replaceArgsReferencesInBuildArgs:(TyphoonRuntimeArguments *)definitionCallArgs withRuntimeArgs:(TyphoonRuntimeArguments *)runtimeArgs
{
    if (definitionCallArgs && runtimeArgs) {
        
        NSUInteger indexToReplace;
        Class argumentInjectionClass = [TyphoonPropertyInjectedWithRuntimeArg class];
        
        while ((indexToReplace = [definitionCallArgs indexOfArgumentWithKind:argumentInjectionClass]) != NSNotFound) {
            TyphoonPropertyInjectedWithRuntimeArg *runtimeArgPlaceholder = [definitionCallArgs argumentValueAtIndex:indexToReplace];
            id runtimeValue = [runtimeArgs argumentValueAtIndex:runtimeArgPlaceholder.index];
            [definitionCallArgs replaceArgumentAtIndex:indexToReplace withArgument:runtimeValue];
        }
    }
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonPropertyInjectedByReference alloc] initWithName:[self.name copy] reference:[self.reference copy]];
}

@end
