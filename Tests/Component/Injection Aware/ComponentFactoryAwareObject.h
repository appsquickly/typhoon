//
//  ComponentFactoryAwareObject.h
//  Tests
//
//  Created by Robert Gilliam on 8/4/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonComponentFactoryAware.h"

@interface ComponentFactoryAwareObject : NSObject <TyphoonComponentFactoryAware>

@property(readonly) id factory;

@end
