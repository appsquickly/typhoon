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


@interface TyphoonWrappedSelector : NSObject

+ (TyphoonWrappedSelector*)wrappedSelectorWithName:(NSString*)string;
+ (TyphoonWrappedSelector*)wrappedSelectorWithSelector:(SEL)pSelector;

- (id)initWithName:(NSString*)string;
- (id)initWithSelector:(SEL)pSelector;

@property (readonly) SEL selector;

@end