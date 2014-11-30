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

@class TyphoonDefinition;
@class TyphoonComponentFactory;

/**
* @ingroup Factory
*
*/
@interface TyphoonDefinitionRegisterer : NSObject

- (id)initWithDefinition:(TyphoonDefinition *)definition componentFactory:(TyphoonComponentFactory *)componentFactory;

- (void)doRegistration;

@end