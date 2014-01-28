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
#import "TyphoonInjectedParameter.h"

/**
* Represents a parameter injected with an instance of an object - something constructed outside of the container.
*/
@interface TyphoonParameterInjectedWithObjectInstance : NSObject <TyphoonInjectedParameter>

@property(nonatomic, readonly) NSUInteger index;
@property(nonatomic, readonly) TyphoonParameterInjectionType type;
@property(nonatomic, strong, readonly) id value;

- (id)initWithParameterIndex:(NSUInteger)index value:(id)value;

- (BOOL) isPrimitiveParameterForClass:(Class)aClass isClassMethod:(BOOL)isClassMethod;

@end
