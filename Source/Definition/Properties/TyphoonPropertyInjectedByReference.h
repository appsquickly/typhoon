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
#import "TyphoonInjectedByReference.h"

/**

* Represents a property injected by referencing another definition in the container.
*/
@interface TyphoonPropertyInjectedByReference : TyphoonInjectedByReference

- (instancetype)initWithName:(NSString*)name reference:(NSString*)reference;

@end
