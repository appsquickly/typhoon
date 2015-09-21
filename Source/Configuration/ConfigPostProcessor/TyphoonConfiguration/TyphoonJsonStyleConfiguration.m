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

#import "TyphoonJsonStyleConfiguration.h"
#import "TyphoonResource.h"


@implementation TyphoonJsonStyleConfiguration
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

- (NSString *)stringWithoutCommentsFromString:(NSString *)string
{
    static NSRegularExpression *expression;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        expression = [NSRegularExpression regularExpressionWithPattern:@"(([\"'])(?:\\\\\\2|.)*?\\2)|(\\/\\/[^\\n\\r]*(?:[\\n\\r]+|$)|(\\/\\*(?:(?!\\*\\/).|[\\n\\r])*\\*\\/))"
            options:NSRegularExpressionAnchorsMatchLines error:nil];
    });

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
    NSArray *matches = [expression matchesInString:string options:0 range:NSMakeRange(0, string.length)];
#pragma clang diagnostic pop
    
    if ([matches count] > 0) {
        NSMutableString *mutableString = [string mutableCopy];
        [matches enumerateObjectsWithOptions:NSEnumerationReverse
            usingBlock:^(NSTextCheckingResult *match, NSUInteger idx, BOOL *stop) {
                unichar character = [string characterAtIndex:match.range.location];
                if (character != '\'' && character != '\"') {
                    [mutableString replaceCharactersInRange:match.range withString:@""];
                }
            }];
        string = mutableString;
    }

    return string;
}

- (void)appendResource:(id<TyphoonResource>)resource
{
    NSString *jsonWithoutComments = [self stringWithoutCommentsFromString:[resource asString]];
    NSData *jsonData = [jsonWithoutComments dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments
        error:&error];

    if (!error) {
        [_properties addEntriesFromDictionary:dictionary];
    }
    else {
        [NSException raise:NSInvalidArgumentException format:@"Can't parse JSON configuration file: %@", error];
    }
}

- (id)objectForKey:(NSString *)key
{
    return [_properties valueForKeyPath:key];
}

@end
