////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
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
    NSMutableSet *collaboratingAssemblyProperties = [[NSMutableSet alloc] init];

    NSSet *properties = [TyphoonIntrospectionUtils propertiesForClass:[_assembly class] upToParentClass:[TyphoonAssembly class]];
    
    for (NSString *property in properties) {
        if ([self propertyForName:property isCollaboratingAssemblyPropertyOnClass:[_assembly class]]) {
            [collaboratingAssemblyProperties addObject:property];
        }
    }
    
    return collaboratingAssemblyProperties;
}

- (BOOL)propertyForName:(NSString *)propertyName isCollaboratingAssemblyPropertyOnClass:(Class)class
{
    TyphoonTypeDescriptor *type = [TyphoonIntrospectionUtils typeForPropertyNamed:propertyName inClass:class];
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
