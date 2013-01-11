////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2012 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "SpringComponentFactoryMutator.h"

@protocol SpringResource;


@interface SpringPropertyPlaceholderConfigurer : NSObject <SpringComponentFactoryMutator>
{
    NSString* _prefix;
    NSString* _suffix;
    NSMutableDictionary* _properties;
}

+ (SpringPropertyPlaceholderConfigurer*)configurer;

- (id)initWithPrefix:(NSString*)prefix suffix:(NSString*)suffix;

- (void)usePropertyStyleResource:(id <SpringResource>)resource;

- (NSDictionary*)properties;

@end