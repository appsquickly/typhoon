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
#import "TyphoonComponentFactoryAware.h"

#import "TyphoonComponentFactory.h"
#import "ComponentFactoryAwareAssembly.h"

@interface ComponentFactoryAwareObject : NSObject <TyphoonComponentFactoryAware>

@property(readonly) id factory;

@property(nonatomic, strong) ComponentFactoryAwareAssembly *assembly;
@property(nonatomic, strong) TyphoonComponentFactory *componentFactory;

- (id) initWithComponentFactory:(TyphoonComponentFactory *)factory;

@end
