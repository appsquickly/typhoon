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
#import "TyphoonComponentFactory.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"


@implementation TyphoonTypeConvertedCollectionValue

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithTextValue:(NSString *)textValue requiredType:(Class)requiredType
{
    self = [super init];
    if (self) {
        _textValue = textValue;
        _requiredType = requiredType;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (id)resolveWithFactory:(TyphoonComponentFactory *)factory
{
    TyphoonTypeDescriptor *descriptor = [TyphoonTypeDescriptor descriptorWithClassOrProtocol:self.requiredType];
    id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:descriptor];
    id converted = [converter convert:self.textValue];
    return converted;
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonTypeConvertedCollectionValue alloc] initWithTextValue:_textValue requiredType:_requiredType];
}


@end
