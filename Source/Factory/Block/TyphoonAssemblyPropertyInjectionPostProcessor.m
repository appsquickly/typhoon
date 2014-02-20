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


#import "TyphoonAssemblyPropertyInjectionPostProcessor.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinition.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonAssembly.h"
#import "TyphoonPropertyInjectedByComponentFactory.h"

@implementation TyphoonAssemblyPropertyInjectionPostProcessor

- (BOOL) shouldReplaceInjectionByType:(TyphoonPropertyInjectedByType *)propertyInjection withFactoryInjectionInDefinition:(TyphoonDefinition *)definition
{
    BOOL isAssemblyClass = NO;
    
    TyphoonTypeDescriptor *type = [TyphoonIntrospectionUtils typeForPropertyWithName:propertyInjection.name inClass:definition.type];
    
    if (type.typeBeingDescribed) {
        isAssemblyClass = [type.typeBeingDescribed isSubclassOfClass:[TyphoonAssembly class]];
    }
    
    return isAssemblyClass;
}

@end
