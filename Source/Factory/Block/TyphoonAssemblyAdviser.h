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


#import <Foundation/Foundation.h>

@class TyphoonAssembly;


@interface TyphoonAssemblyAdviser : NSObject

// all these methods want to be on the TyphoonAssembly?
// or, initWithAssembly?
+ (void)adviseMethods:(TyphoonAssembly*)assembly;

+ (NSSet*)definitionSelectors:(TyphoonAssembly*)assembly;

+ (BOOL)assemblyMethodsSwizzled:(TyphoonAssembly*)assembly;

+ (BOOL)assemblyMethodsHaveNotYetBeenSwizzled:(TyphoonAssembly*)assembly;

+ (void)markAssemblyMethodsAsSwizzled:(TyphoonAssembly*)assembly;

+ (void)replaceImplementationOfDefinitionSelector:(NSValue*)obj withDynamicBeforeAdviceImplementationOnAssembly:(TyphoonAssembly*)assembly;

@end