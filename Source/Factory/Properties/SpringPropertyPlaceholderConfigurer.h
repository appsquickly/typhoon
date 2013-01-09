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
#import <Spring-OSX/SpringComponentFactoryMutator.h>

@protocol SpringResource;


@interface SpringPropertyPlaceholderConfigurer : NSObject<SpringComponentFactoryMutator>
{
    NSString* _prefix;
    NSString* _suffix;
    NSMutableArray* _propertyResources;
}

+ (SpringPropertyPlaceholderConfigurer*)configurer;

- (id)initWithPrefix:(NSString*)aPrefix suffix:(NSString*)aSuffix;

- (void)usePropertyResource:(id<SpringResource>)resource;

@end