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

#import "TyphoonDefinition.h"

@class TyphoonPropertyPlaceholderConfigurer;
@protocol TyphoonResource;

/**
 Declares short-hand definition factory methods for infrastructure components.
 */
@interface TyphoonDefinition (Infrastructure)

+ (TyphoonDefinition*)propertyPlaceholderWithResource:(id<TyphoonResource>)resource;

@end
