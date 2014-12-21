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

@class TyphoonRuntimeArguments;

typedef void(^TyphoonInjectionValueBlock)(id value);

@interface TyphoonInjectionContext : NSObject <NSCopying>

@property(nonatomic, strong, readonly) TyphoonComponentFactory* factory;
@property(nonatomic, strong, readonly) TyphoonRuntimeArguments* args;
@property(nonatomic, readonly) BOOL raiseExceptionIfCircular;

/** Class of destination instance, - used only for better exception description */
@property(nonatomic, assign, readwrite) Class classUnderConstruction;
@property(nonatomic, strong, readwrite) TyphoonTypeDescriptor* destinationType;

- (instancetype)initWithFactory:(TyphoonComponentFactory*)factory args:(TyphoonRuntimeArguments*)args
    raiseExceptionIfCircular:(BOOL)raiseExceptionIfCircular;


@end
