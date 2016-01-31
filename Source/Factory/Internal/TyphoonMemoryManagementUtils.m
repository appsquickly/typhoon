////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonMemoryManagementUtils.h"
#import <objc/runtime.h>

@class TyphoonComponentFactory;
@class TyphoonAssembly;

static const char *kFactoryAssembliesKey;
static const char *kAssemblyFactoryKey;

@implementation TyphoonMemoryManagementUtils

+ (void)makeFactory:(TyphoonComponentFactory *)factory retainAssemblies:(NSSet *)assemblies
{
    objc_setAssociatedObject(factory, &kFactoryAssembliesKey, assemblies, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    for (TyphoonAssembly *assembly in assemblies) {
        objc_setAssociatedObject(assembly, &kAssemblyFactoryKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

+ (void)makeAssemblies:(NSSet *)assemblies retainFactory:(TyphoonComponentFactory *)factory
{
    objc_setAssociatedObject(factory, &kFactoryAssembliesKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    for (TyphoonAssembly *assembly in assemblies) {
        objc_setAssociatedObject(assembly, &kAssemblyFactoryKey, factory, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end
