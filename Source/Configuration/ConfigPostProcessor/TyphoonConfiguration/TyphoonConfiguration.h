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

@protocol TyphoonResource;

@protocol TyphoonConfiguration <NSObject>

- (void)appendResource:(id<TyphoonResource>)resource;

- (id)objectForKey:(NSString *)key;

@end
