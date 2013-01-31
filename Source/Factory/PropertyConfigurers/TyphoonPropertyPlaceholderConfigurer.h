////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "TyphoonComponentFactoryMutator.h"

@protocol TyphoonResource;


@interface TyphoonPropertyPlaceholderConfigurer : NSObject <TyphoonComponentFactoryMutator>
{
    NSString* _prefix;
    NSString* _suffix;
    NSMutableDictionary* _properties;
}

+ (TyphoonPropertyPlaceholderConfigurer*)configurer;

+ (TyphoonPropertyPlaceholderConfigurer*)configurerWithResource:(id<TyphoonResource>)resource;

+ (TyphoonPropertyPlaceholderConfigurer*)configurerWithResources:(id<TyphoonResource>)first, ...NS_REQUIRES_NIL_TERMINATION;

- (id)initWithPrefix:(NSString*)prefix suffix:(NSString*)suffix;

- (void)usePropertyStyleResource:(id <TyphoonResource>)resource;

- (NSDictionary*)properties;

@end