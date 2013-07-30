////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////




#import "TyphoonPropertyInjectedByValue.h"


@implementation TyphoonPropertyInjectedByValue



@synthesize textValue = _textValue;

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