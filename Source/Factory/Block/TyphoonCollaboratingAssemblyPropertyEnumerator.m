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
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"

@implementation TyphoonCollaboratingAssemblyPropertyEnumerator
{

}

- (id)initWithAssembly:(TyphoonAssembly *)assembly
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

    Class class = [self.assembly class];
    while ([self classNotRootAssemblyClass:class]) {
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(class, &count);
        for (int propertyIndex = 0; propertyIndex < count; propertyIndex++) {
            objc_property_t aProperty = properties[propertyIndex];

            NSString *propertyName = [self propertyNameForProperty:aProperty];
            if ([self propertyForName:propertyName isCollaboratingAssemblyPropertyOnClass:class]) {
                [propertyNames addObject:propertyName];
            }
        }

        class = class_getSuperclass(class);
    }

    return propertyNames;
}

- (BOOL)propertyForName:(NSString *)propertyName isCollaboratingAssemblyPropertyOnClass:(Class)class
{
    TyphoonTypeDescriptor *type = [TyphoonIntrospectionUtils typeForPropertyWithName:propertyName inClass:class];
    return [type.typeBeingDescribed isSubclassOfClass:[TyphoonAssembly class]];
}

- (BOOL)classNotRootAssemblyClass:(Class)class
{
    return class != [TyphoonAssembly class];
}

- (id)propertyNameForProperty:(objc_property_t)aProperty
{
    const char *cPropertyName = property_getName(aProperty);
    return [NSString stringWithCString:cPropertyName encoding:NSUTF8StringEncoding];
}

@end