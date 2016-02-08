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


#import <Foundation/Foundation.h>

@class TyphoonComponentFactory;

@interface TyphoonMemoryManagementUtils : NSObject

+ (void)makeFactory:(TyphoonComponentFactory *)factory retainAssemblies:(NSSet *)assemblies;

+ (void)makeAssemblies:(NSSet *)assemblies retainFactory:(TyphoonComponentFactory *)factory;

@end
