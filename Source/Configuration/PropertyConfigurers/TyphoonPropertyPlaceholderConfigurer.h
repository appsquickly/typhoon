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
{
    NSString *_prefix;
    NSString *_suffix;
    NSMutableDictionary *_properties;
}

+ (TyphoonPropertyPlaceholderConfigurer *)configurer;

+ (TyphoonPropertyPlaceholderConfigurer *)configurerWithResource:(id <TyphoonResource>)resource;

+ (TyphoonPropertyPlaceholderConfigurer *)configurerWithResources:(id <TyphoonResource>)first, ...NS_REQUIRES_NIL_TERMINATION;

+ (TyphoonPropertyPlaceholderConfigurer *)configurerWithResourceList:(NSArray *)resources;

- (id)initWithPrefix:(NSString *)prefix suffix:(NSString *)suffix;

- (void)usePropertyStyleResource:(id <TyphoonResource>)resource;

- (NSDictionary *)properties;

@end
