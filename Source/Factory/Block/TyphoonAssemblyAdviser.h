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

+ (void)adviseMethods:(TyphoonAssembly*)assembly;
+ (void)undoAdviseMethods:(TyphoonAssembly*)assembly;

+ (NSSet*)definitionSelectorsForAssembly:(TyphoonAssembly*)assembly;

+ (BOOL)assemblyMethodsSwizzled:(TyphoonAssembly*)assembly;
+ (BOOL)assemblyMethodsHaveNotYetBeenSwizzled:(TyphoonAssembly*)assembly;
+ (BOOL)assemblyMethodsSwizzledOnClass:(Class)class;

+ (void)swapImplementationOfDefinitionSelector:(NSValue*)obj withDynamicBeforeAdviceImplementationOnAssembly:(TyphoonAssembly*)assembly;

@end