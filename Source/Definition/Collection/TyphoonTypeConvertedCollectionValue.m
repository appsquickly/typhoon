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


@end
