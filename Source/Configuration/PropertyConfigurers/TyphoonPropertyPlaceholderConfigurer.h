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
#import "TyphoonComponentFactoryPostProcessor.h"

@protocol TyphoonResource;

/**
* @ingroup Configuration
*/
@interface TyphoonPropertyPlaceholderConfigurer : NSObject <TyphoonComponentFactoryPostProcessor>

+ (TyphoonPropertyPlaceholderConfigurer *)configurer;

+ (TyphoonPropertyPlaceholderConfigurer *)configurerWithResource:(id <TyphoonResource>)resource;

+ (TyphoonPropertyPlaceholderConfigurer *)configurerWithResources:(id <TyphoonResource>)first, ...NS_REQUIRES_NIL_TERMINATION;

+ (TyphoonPropertyPlaceholderConfigurer *)configurerWithResourceList:(NSArray *)resources;

- (void)usePropertyStyleResource:(id <TyphoonResource>)resource;

- (void)useJsonStyleResource:(id <TyphoonResource>)resource;

- (NSDictionary *)properties UNAVAILABLE_ATTRIBUTE;

@end

/** Returns injection */
id TyphoonConfig(NSString *configKey);
