////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2012 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "SpringPropertyPlaceholderConfigurer.h"
#import "SpringResource.h"
#import "SpringComponentDefinition.h"
#import "SpringPropertyInjectedByValue.h"

@implementation SpringPropertyPlaceholderConfigurer

/* =========================================================== Class Methods ============================================================ */
+ (SpringPropertyPlaceholderConfigurer*)configurer
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
- (void)usePropertyStyleResource:(id <SpringResource>)resource
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
    for (SpringComponentDefinition* definition in componentDefinitions)
    {
        for (SpringPropertyInjectedByValue* property in [definition propertiesInjectedByValue])
        {
            if ([property.textValue hasPrefix:_prefix] && [property.textValue hasSuffix:_suffix])
            {

            }
        }
    }
}

@end