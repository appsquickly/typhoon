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




#import "SpringPropertyInjectedByValue.h"


@implementation SpringPropertyInjectedByValue
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
- (SpringPropertyInjectionType)type
{
    return SpringPropertyInjectionByValueType;
}

/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.name=%@", self.name];
    [description appendFormat:@", self.value=%@", self.textValue];
    [description appendString:@">"];
    return description;
}


@end