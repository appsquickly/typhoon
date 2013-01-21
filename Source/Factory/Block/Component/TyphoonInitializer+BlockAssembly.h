////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2013 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "TyphoonInitializer.h"

@interface TyphoonInitializer (BlockAssembly)

- (void)injectWithDefinition:(TyphoonDefinition*)definition;

- (void)injectParameterNamed:(NSString*)name withDefinition:(TyphoonDefinition*)definition;

- (void)injectParameterAtIndex:(NSUInteger)index1 withDefinition:(TyphoonDefinition*)definition;

@end