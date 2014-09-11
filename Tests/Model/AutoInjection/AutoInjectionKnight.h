//
// Created by Aleksey Garbarev on 12.09.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Knight.h"
#import "TyphoonAutoInjection.h"


@interface AutoInjectionKnight : Knight

@property(nonatomic, strong) InjectedProtocol(Quest) autoQuest;
@property(nonatomic, strong) InjectedClass(Fort) autoFort;

@end