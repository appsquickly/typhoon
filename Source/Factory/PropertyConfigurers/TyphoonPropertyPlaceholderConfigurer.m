////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "TyphoonResource.h"
#import "TyphoonComponentDefinition.h"
#import "TyphoonPropertyInjectedByValue.h"

@interface TyphoonPropertyInjectedByValue (PropertyPlaceHolderConfigurer)

- (void)setTextValue:(NSString*)textValue;

@end


@implementation TyphoonPropertyInjectedByValue (PropertyPlaceHolderConfigurer)

- (void)setTextValue:(NSString*)textValue
{
    _textValue = textValue;
}


@end

@implementation TyphoonPropertyPlaceholderConfigurer

/* =========================================================== Class Methods ============================================================ */
+ (TyphoonPropertyPlaceholderConfigurer*)configurer
{
    return [[[self class] alloc] init];
}

/* ============================================================ Initializers ============================================================ */
- (id)initWithPrefix:(NSString*)prefix suffix:(NSString*)suffix
{
    self = [super init];
    if (self)
    {
        _prefix = prefix;
        _suffix = suffix;
        _properties = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)init
{
    return [self initWithPrefix:@"${" suffix:@"}"];
}

/* ========================================================== Interface Methods ========================================================= */
- (void)usePropertyStyleResource:(id <TyphoonResource>)resource
{
    NSArray* lines = [[resource asString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString* line in lines)
    {
        NSRange range = [line rangeOfString:@"="];
        if (range.location != NSNotFound)
        {
            NSString* property = [line substringToIndex:range.location];
            NSString* value = [line substringFromIndex:range.location + range.length];
            [_properties setObject:value forKey:property];
        }
    }
}

- (NSDictionary*)properties
{
    return [_properties copy];
}


/* =========================================================== Protocol Methods ========================================================= */
- (void)mutateComponentDefinitionsIfRequired:(NSArray*)componentDefinitions
{
    for (TyphoonComponentDefinition* definition in componentDefinitions)
    {
        for (TyphoonPropertyInjectedByValue* property in [definition propertiesInjectedByValue])
        {
            if ([property.textValue hasPrefix:_prefix] && [property.textValue hasSuffix:_suffix])
            {
                NSString* key = [property.textValue substringFromIndex:[_prefix length]];
                key = [key substringToIndex:[key length] - [_suffix length]];
                NSString* value = [_properties valueForKey:key];
                NSLog(@"Setting property '%@' to value '%@'", key, value);
                property.textValue = value;
            }
        }
    }
}

@end