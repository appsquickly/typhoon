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




#import "TyphoonPropertyInjectedByValue.h"


@implementation TyphoonPropertyInjectedByValue
{

}

/* ============================================================ Initializers ============================================================ */
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

/* =========================================================== Protocol Methods ========================================================= */
- (TyphoonPropertyInjectionType)injectionType
{
    return TyphoonPropertyInjectionByValueType;
}


@end