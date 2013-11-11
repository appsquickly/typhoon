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


@interface TyphoonAssembly : NSObject
{
    NSMutableDictionary* _cachedDefinitions;
}

+ (instancetype)assembly;

/**
* Returns the [TyphoonComponentFactory defaultFactory], with components exposed using an assembly interface.
*/
+ (instancetype)defaultAssembly;

/**
* Callback to wire any collaborating assemblies to either a hard-coded reference or a proxy that will be resolved at runtime.
*/
- (void)resolveCollaboratingAssemblies;


@end
