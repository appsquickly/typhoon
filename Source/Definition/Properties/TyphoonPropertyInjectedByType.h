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
#import "TyphoonAbstractInjectedProperty.h"

/**
* Represents a property injected by matching a definition of the required type from the container.
*/
@interface TyphoonPropertyInjectedByType : TyphoonAbstractInjectedProperty

- (id)initWithName:(NSString *)name;


@end
