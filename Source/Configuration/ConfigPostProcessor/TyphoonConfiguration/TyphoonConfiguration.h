//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

@protocol TyphoonResource;

@protocol TyphoonConfiguration <NSObject>

- (void)appendResource:(id<TyphoonResource>)resource;

- (id)objectForKey:(NSString *)key;

@end