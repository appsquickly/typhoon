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
#import "TyphoonTypeDescriptor.h"
#import "TyphoonComponentFactory.h"

typedef void(^TyphoonInjectionValueBlock)(id value);

@interface TyphoonInjectionContext : NSObject<NSCopying>

@property(nonatomic, strong) TyphoonTypeDescriptor *destinationType;
@property(nonatomic, strong) TyphoonComponentFactory *factory;
@property(nonatomic, strong) TyphoonRuntimeArguments *args;

/** Class of destination instance, - used only for better exception description */
@property(nonatomic, assign) Class destinationInstanceClass;

@property(nonatomic) BOOL raiseExceptionIfCircular;

@end
