//
//  TyphoonComponentFactoryAware.h
//  Static Library
//
//  Created by Robert Gilliam on 8/4/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TyphoonComponentFactoryAware <NSObject>

- (void)setFactory:(id)theFactory;

@end
