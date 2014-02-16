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

#import "TyphoonURLUtils.h"


@implementation TyphoonURLUtils

+ (NSURL *)URL:(NSURL *)url appendedWithQueryParameters:(NSDictionary *)parameters
{
    NSMutableString *urlString = [[NSMutableString alloc] initWithString:[url absoluteString]];

    for (id key in parameters) {
        NSString *keyString = [key description];
        NSString *valueString = [[parameters objectForKey:key] description];

        if ([urlString rangeOfString:@"?"].location == NSNotFound) {
            [urlString appendFormat:@"?%@=%@", [self URLEscapeString:keyString], [self URLEscapeString:valueString]];
        }
        else {
            [urlString appendFormat:@"&%@=%@", [self URLEscapeString:keyString], [self URLEscapeString:valueString]];
        }
    }
    return [NSURL URLWithString:urlString];
}

+ (NSString *)URLEscapeString:(NSString *)rawString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef) rawString;
    NSString *encoded =
        (__bridge_transfer NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, originalStringRef, NULL, NULL, kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return encoded;
}


@end