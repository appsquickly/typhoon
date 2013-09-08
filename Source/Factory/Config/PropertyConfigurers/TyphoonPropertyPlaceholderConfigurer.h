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
#import "TyphoonComponentFactoryMutator.h"

@protocol TyphoonResource;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@interface TyphoonPropertyPlaceholderConfigurer : NSObject <TyphoonComponentFactoryPostProcessor, TyphoonComponentFactoryMutator>
#pragma clang diagnostic pop
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