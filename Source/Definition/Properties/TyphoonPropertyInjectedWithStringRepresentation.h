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
#import "TyphoonInjectedWithStringRepresentation.h"

/**
* Represents a property injected with a string representation. The type converter system will convert the representation to an instance of
* the required type.
*
* @see TyphoonPropertyPlaceholderConfigurer
*
*/
@interface TyphoonPropertyInjectedWithStringRepresentation : TyphoonAbstractInjectedProperty <TyphoonInjectedWithStringRepresentation>

- (id)initWithName:(NSString *)name value:(NSString *)value;


@end
