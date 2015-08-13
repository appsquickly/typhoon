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


#import "TyphoonInjectionByComponentFactory.h"
#import "NSInvocation+TCFUnwrapValues.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonAssembly.h"

@interface TyphoonAssembly (Activation)

- (void)activateWithFactory:(TyphoonComponentFactory *)factory collaborators:(NSSet *)collaborators;

@end

@implementation TyphoonInjectionByComponentFactory

#pragma mark - Overrides

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    id factoryType = context.destinationType.classOrProtocol;
    
    // TODO: Ideally we shouldn't create a new instance of an assembly, but somehow reference the original one. This can be achieved by either merging TyphoonComponentFactory and TyphoonBlockComponentFactory, or by adding a new injection - TyphoonInjectionByAssembly. In the second case the problem is in TyphoonFactoryPropertyInjectionPostProcessor - it doesn't have enough context to create such injection.
    if (IsClass(factoryType)) {
        Class factoryClass = factoryType;
        BOOL isAssemblySubclass = [factoryClass isSubclassOfClass:[TyphoonAssembly class]];
        if (isAssemblySubclass) {
            id assembly = [[factoryClass alloc] init];
            [assembly activateWithFactory:context.factory collaborators:nil];
            result(assembly);
            return;
        }
    }
    
    result(context.factory);
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByComponentFactory *copied = [[TyphoonInjectionByComponentFactory alloc] init];
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (BOOL)isEqualToCustom:(TyphoonInjectionByComponentFactory *)injection
{
    return YES;
}

@end
