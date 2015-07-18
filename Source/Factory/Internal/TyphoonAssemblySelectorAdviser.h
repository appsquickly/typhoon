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

#import <Foundation/Foundation.h>

@interface TyphoonAssemblySelectorAdviser : NSObject

+ (SEL)advisedSELForKey:(NSString *)key class:(Class)clazz;

+ (SEL)advisedSELForSEL:(SEL)unwrappedSEL class:(Class)clazz;

+ (NSString *)keyForAdvisedSEL:(SEL)selWithAdvicePrefix;

+ (NSString *)keyForSEL:(SEL)sel;

+ (BOOL)selectorIsAdvised:(SEL)sel;

+ (NSString *)advisedNameForName:(NSString *)string class:(Class)clazz;
@end
