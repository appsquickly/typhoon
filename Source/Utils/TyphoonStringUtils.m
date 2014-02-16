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


#import "TyphoonStringUtils.h"


@implementation TyphoonStringUtils


+ (BOOL)isAlpha:(NSString *)candidate
{
    return [self isMemberOfCharacterSet:candidate characterSet:[NSCharacterSet letterCharacterSet]];
}

+ (BOOL)isAlphaOrSpaces:(NSString *)candidate
{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet letterCharacterSet];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [self isMemberOfCharacterSet:candidate characterSet:characterSet];
}

+ (BOOL)isAlphanumeric:(NSString *)candidate
{
    return [self isMemberOfCharacterSet:candidate characterSet:[NSCharacterSet alphanumericCharacterSet]];
}


+ (BOOL)isMemberOfCharacterSet:(NSString *)string characterSet:(NSMutableCharacterSet *)characterSet
{
    return ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) ? NO : YES;
}

+ (BOOL)isEmpty:(NSString *)candidate
{
    if ([candidate length] == 0) {
        return YES;
    }

    if (![[candidate stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNotEmpty:(NSString *)candidate
{
    return ![self isEmpty:candidate];
}

+ (BOOL)isEmailAddress:(NSString *)candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL)string:(NSString *)string containsString:(NSString *)contains
{
    return [string rangeOfString:contains].location != NSNotFound;
}


@end
