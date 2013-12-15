//
// Created by Robert Gilliam on 12/14/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TyphoonWrappedSelector : NSObject

+ (TyphoonWrappedSelector*)withName:(NSString*)string;

- (id)initWithName:(NSString*)string;
@end