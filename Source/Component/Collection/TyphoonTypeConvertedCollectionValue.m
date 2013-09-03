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

#import "TyphoonTypeConvertedCollectionValue.h"


@implementation TyphoonTypeConvertedCollectionValue

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithTextValue:(NSString*)textValue requiredType:(Class)requiredType
{
    self = [super init];
    if (self)
    {
        _textValue = textValue;
        _requiredType = requiredType;
    }
    return self;
}

- (TyphoonCollectionValueType)type
{
    return TyphoonCollectionValueTypeConvertedText;
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.textValue=%@", self.textValue];
    [description appendFormat:@", self.requiredType=%@", self.requiredType];
    [description appendString:@">"];
    return description;
}

@end