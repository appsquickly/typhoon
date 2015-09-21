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

@class TyphoonDefinition;
@class TyphoonComponentFactory;

/**
* @ingroup Assembly
*
*/
@interface TyphoonDefinitionRegisterer : NSObject

- (id)initWithDefinition:(TyphoonDefinition *)definition componentFactory:(TyphoonComponentFactory *)componentFactory;

- (void)doRegistration;

@end
