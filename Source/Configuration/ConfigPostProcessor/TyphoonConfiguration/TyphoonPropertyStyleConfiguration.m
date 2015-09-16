////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonPropertyStyleConfiguration.h"
#import "TyphoonResource.h"

@implementation TyphoonPropertyStyleConfiguration
{
    NSMutableDictionary *_properties;
}

- (id)init
{
    self = [super init];
    if (self) {
        _properties = [NSMutableDictionary new];
    }
    return self;
}

- (void)appendResource:(id<TyphoonResource>)resource
{
    NSArray *lines = [[resource asString] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString *line in lines) {
        if (![line hasPrefix:@"#"]) {
            NSRange range = [line rangeOfString:@"="];
            if (range.location != NSNotFound) {
                NSString *property = [line substringToIndex:range.location];
                NSString *value = [line substringFromIndex:range.location + range.length];
                [_properties setObject:value forKey:property];
            }
        }
    }
}

- (id)objectForKey:(NSString *)key
{
    return _properties[key];
}

@end
