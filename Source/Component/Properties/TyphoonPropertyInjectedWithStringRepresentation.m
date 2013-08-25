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




#import "TyphoonPropertyInjectedWithStringRepresentation.h"

/**
* Represents a property injected with a string representation. The type converter system will convert the representation to an instance of
* an object of the required type.
*
* @see TyphoonPropertyPlaceholderConfigurer
*/
@implementation TyphoonPropertyInjectedWithStringRepresentation



@synthesize textValue = _textValue;

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithName:(NSString*)name value:(NSString*)value
{
    self = [super init];
    if (self)
    {
        _name = name;
        _textValue = value;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (TyphoonPropertyInjectionType)injectionType
{
    return TyphoonPropertyInjectionTypeAsStringRepresentation;
}


@end