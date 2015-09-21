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


#import <Foundation/Foundation.h>
#import "TyphoonDefinition.h"


@interface TyphoonFactoryDefinition : TyphoonDefinition

@property (nonatomic, strong) id classOrProtocolForAutoInjection;

- (id)initWithFactory:(id)factory selector:(SEL)selector parameters:(void(^)(TyphoonMethod *method))params;

- (void)useInitializer:(SEL)selector parameters:(void (^)(TyphoonMethod *initializer))parametersBlock __attribute((unavailable("Initializer of TyphoonFactoryDefinition cannot be changed")));

- (void)useInitializer:(SEL)selector __attribute((unavailable("Initializer of TyphoonFactoryDefinition cannot be changed")));

@end
