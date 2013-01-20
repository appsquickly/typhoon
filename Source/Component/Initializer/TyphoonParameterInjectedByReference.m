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



#import "TyphoonParameterInjectedByReference.h"
#import "TyphoonComponentInitializer.h"


@implementation TyphoonParameterInjectedByReference

/* ============================================================ Initializers ============================================================ */
- (id)initWithParameterIndex:(NSUInteger)parameterIndex reference:(NSString*)reference
{
    self = [super init];
    if (self)
    {
        _index = parameterIndex;
        _reference = reference;
    }
    return self;
}

/* =========================================================== Protocol Methods ========================================================= */
- (TyphoonParameterInjectionType)type
{
    return TyphoonParameterInjectedByReferenceType;
}

- (void)setInitializer:(TyphoonComponentInitializer*)initializer
{
    //Do nothing.
}

/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.parameterIndex=%lu", self.index];
    [description appendFormat:@", self.reference=%@", self.reference];
    [description appendString:@">"];
    return description;
}


@end