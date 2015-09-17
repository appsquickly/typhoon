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

@interface TyphoonComponentFactory (CollaboratingInjection)

- (id)componentInjectionFactoryForCollaboratingAssembly:(Class)factoryClass;

@end

@implementation TyphoonInjectionByComponentFactory

#pragma mark - Overrides

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    id factoryType = context.destinationType.classOrProtocol;
    id value = context.factory;

    if (IsClass(factoryType)) {
        Class factoryClass = factoryType;
        BOOL isAssemblySubclass = [factoryClass isSubclassOfClass:[TyphoonAssembly class]];
        if (isAssemblySubclass) {
            value = [context.factory componentInjectionFactoryForCollaboratingAssembly:factoryClass];
        }
    }
    
    result(value);
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
