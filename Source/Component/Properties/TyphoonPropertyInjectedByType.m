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



#import "TyphoonPropertyInjectedByType.h"


@implementation TyphoonPropertyInjectedByType


/* ============================================================ Initializers ============================================================ */
- (id)initWithName:(NSString*)name
{
    self = [super init];
    if (self)
    {
        _name = name;
    }
    return self;
}

/* =========================================================== Protocol Methods ========================================================= */
- (TyphoonPropertyInjectionType)type
{
    return TyphoonPropertyInjectionByTypeType;
}


@end