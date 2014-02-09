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

@interface TyphoonAssemblySelectorAdviser : NSObject

+ (SEL)advisedSELForKey:(NSString *)key;

+ (NSString *)keyForAdvisedSEL:(SEL)selWithAdvicePrefix;

+ (NSString *)keyForSEL:(SEL)sel;

+ (BOOL)selectorIsAdvised:(SEL)sel;

+ (SEL)advisedSELForSEL:(SEL)unwrappedSEL;

+ (NSString *)advisedNameForName:(NSString *)string;
@end
