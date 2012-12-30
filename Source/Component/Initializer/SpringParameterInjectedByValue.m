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


#import "SpringParameterInjectedByValue.h"


@implementation SpringParameterInjectedByValue

/* ============================================================ Initializers ============================================================ */
- (id)initWithIndex:(NSUInteger)index value:(NSString*)value classOrProtocol:(id)classOrProtocol
{
    self = [super init];
    if (self)
    {
        _index = index;
        _value = value;
        _classOrProtocol = classOrProtocol;
    }
    return self;
}
/* =========================================================== Protocol Methods ========================================================= */
- (SpringParameterInjectionType)type
{
    return SpringParameterInjectedByValueType;
}

/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.index=%lu", self.index];
    [description appendFormat:@", self.value=%@", self.value];
    [description appendFormat:@", self.classOrProtocol=%@", self.classOrProtocol];
    [description appendString:@">"];
    return description;
}


@end