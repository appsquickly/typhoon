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


#import <Foundation/Foundation.h>


@interface TyphoonStringUtils : NSObject

+ (BOOL)isAlpha:(NSString *)candidate;

+ (BOOL)isAlphaOrSpaces:(NSString *)candidate;

+ (BOOL)isAlphanumeric:(NSString *)candidate;

+ (BOOL)isEmpty:(NSString *)candidate;

+ (BOOL)isNotEmpty:(NSString *)candidate;

+ (BOOL)isEmailAddress:(NSString *)candidate;

+ (BOOL)isMemberOfCharacterSet:(NSString *)string characterSet:(NSMutableCharacterSet *)characterSet;

+ (BOOL)string:(NSString *)string containsString:(NSString *)contains;

@end

#define CStringEquals(stringA, stringB) (stringA == stringB || strcmp(stringA, stringB) == 0)