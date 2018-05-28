//
//  Kingdom.h
//  Typhoon
//
//  Created by Aleksey Garbarev on 28/05/2018.
//  Copyright © 2018 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
@class King;

@interface Kingdom : NSObject

@property (nonatomic) NSString *name;
@property (nonatomic, strong) King *first;
@property (nonatomic, strong) King *second;

@end
