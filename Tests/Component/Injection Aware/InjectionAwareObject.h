//
//  InjectionAwareObject.h
//  Tests
//
//  Created by Robert Gilliam on 8/4/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TyphoonInjectionAware.h>

@interface InjectionAwareObject : NSObject <TyphoonInjectionAware>

@property (readonly) id assembly;

@end
