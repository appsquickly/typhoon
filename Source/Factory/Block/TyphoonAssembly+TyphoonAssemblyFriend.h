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
#import "TyphoonAssembly.h"

@interface TyphoonAssembly (TyphoonAssemblyFriend)

+ (BOOL)selectorIsReserved:(SEL)selector;

- (void)prepareForUse;

- (NSArray *)definitions;

- (TyphoonDefinition *)definitionForKey:(NSString *)key;

@property(readonly) NSSet *definitionSelectors;

@end