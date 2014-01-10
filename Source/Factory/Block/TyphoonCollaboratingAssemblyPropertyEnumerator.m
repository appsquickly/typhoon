////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonCollaboratingAssemblyPropertyEnumerator.h"
#import "TyphoonAssembly.h"
#import <objc/runtime.h>

@implementation TyphoonCollaboratingAssemblyPropertyEnumerator
{

}

- (id)initWithAssembly:(TyphoonAssembly*)assembly
{
    self = [super init];
    if (self) {
        _assembly = assembly;
    }
    return self;
}

- (NSSet *)collaboratingAssemblyProperties
{
    NSMutableSet *propertyNames = [[NSMutableSet alloc] init];

    unsigned int count = 0;
    objc_property_t * properties = class_copyPropertyList([_assembly class], &count);
    for (int propertyIndex = 0; propertyIndex < count; propertyIndex++) {
        objc_property_t aProperty = properties[propertyIndex];
        [propertyNames addObject:[self propertyNameForProperty:aProperty]];
    }

    return propertyNames;
}

- (id)propertyNameForProperty:(objc_property_t)aProperty
{
    const char *cPropertyName = property_getName(aProperty);
    return [NSString stringWithCString:cPropertyName encoding:NSUTF8StringEncoding];
}

@end