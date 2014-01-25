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

@class TyphoonDefinition;

/**
* @ingroup Factory
*
* This class allows using the interface from one assembly within another. This is useful for abstracting out environment dependent
* components. For example you could say "This class X needs to be injected with something conforming to the Foo protocol. This is a
* RealFoo, this is a TestFoo. When I'm running X in real life, I want it to get a RealFoo, but when I'm running my integration tests, I
* want it to get a TestFoo."
*/
@interface TyphoonCollaboratingAssemblyProxy : NSObject

+ (id)proxy;


@end