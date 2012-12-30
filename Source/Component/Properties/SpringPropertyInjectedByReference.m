////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "SpringPropertyInjectedByReference.h"


@implementation SpringPropertyInjectedByReference
{

}

/* ============================================================ Initializers ============================================================ */
- (id)initWithName:(NSString*)name reference:(NSString*)reference
{
    self = [super init];
    if (self)
    {
        _name = name;
        _reference = reference;
    }
    return self;
}

/* =========================================================== Protocol Methods ========================================================= */
- (SpringPropertyInjectionType)type
{
    return SpringPropertyInjectionByReferenceType;
}

/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.name=%@", self.name];
    [description appendFormat:@", self.reference=%@", self.reference];
    [description appendString:@">"];
    return description;
}


@end