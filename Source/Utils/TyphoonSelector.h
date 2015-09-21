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


@interface TyphoonSelector : NSObject

+ (TyphoonSelector *)selectorWithName:(NSString *)string;

+ (TyphoonSelector *)selectorWithSEL:(SEL)pSelector;

- (id)initWithName:(NSString *)string;

- (id)initWithSEL:(SEL)pSelector;

@property(readonly) SEL selector;

@end
