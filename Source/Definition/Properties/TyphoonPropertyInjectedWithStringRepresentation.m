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



#import "TyphoonPropertyInjectedWithStringRepresentation.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonPrimitiveTypeConverter.h"
#import "TyphoonTypeConverterRegistry.h"

/**
* Represents a property injected with a string representation. The type converter system will convert the representation to an instance of
* an object of the required type.
*
* @see TyphoonPropertyPlaceholderConfigurer
*/
@implementation TyphoonPropertyInjectedWithStringRepresentation


@synthesize textValue = _textValue;

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithName:(NSString *)name value:(NSString *)value
{
    self = [super init];
    if (self) {
        _name = name;
        _textValue = value;
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (id)withFactory:(TyphoonComponentFactory *)factory computeValueToInjectOnInstance:(id)instance
{
    TyphoonTypeDescriptor *type = [instance typeForPropertyWithName:self.name];
    id value = nil;

    if (type.isPrimitive) {
        TyphoonPrimitiveTypeConverter *converter = [[TyphoonTypeConverterRegistry shared] primitiveTypeConverter];
        value = [converter valueFromText:self.textValue withType:type];
    }
    else {
        id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:type];
        value = [converter convert:self.textValue];
    }

    return value;
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    return [[TyphoonPropertyInjectedWithStringRepresentation alloc] initWithName:[self.name copy] value:[self.textValue copy]];
}


@end
