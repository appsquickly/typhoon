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
- (TyphoonPropertyInjectionType)injectionType
{
    return TyphoonPropertyInjectionByTypeType;
}


@end