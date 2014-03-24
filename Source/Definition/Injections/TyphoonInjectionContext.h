//
//  TyphoonInjectionContext.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 25.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonTypeDescriptor.h"
#import "TyphoonComponentFactory.h"

typedef void(^TyphoonInjectionValueBlock)(id value);

@interface TyphoonInjectionContext : NSObject<NSCopying>

@property(nonatomic, strong) TyphoonTypeDescriptor *destinationType;
@property(nonatomic, strong) TyphoonComponentFactory *factory;
@property(nonatomic, strong) TyphoonRuntimeArguments *args;

@property(nonatomic) BOOL raiseExceptionIfCircular;

@end
