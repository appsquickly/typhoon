//
// Created by Aleksey Garbarev on 13.09.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonDefinition.h"


@interface TyphoonFactoryDefinition : TyphoonDefinition

@property (nonatomic, strong) id classOrProtocolForAutoInjection;

- (id)initWithFactory:(id)factory selector:(SEL)selector parameters:(void(^)(TyphoonMethod *method))params;

- (void)useInitializer:(SEL)selector parameters:(void (^)(TyphoonMethod *initializer))parametersBlock __attribute((unavailable("Initializer of TyphoonFactoryDefinition cannot be changed")));

- (void)useInitializer:(SEL)selector __attribute((unavailable("Initializer of TyphoonFactoryDefinition cannot be changed")));

@end