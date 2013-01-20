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




#import "TyphoonPropertyInjectedByReference.h"


@implementation TyphoonPropertyInjectedByReference
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
- (TyphoonPropertyInjectionType)type
{
    return TyphoonPropertyInjectionByReferenceType;
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