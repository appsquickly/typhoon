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

@interface TyphoonParameterInjectedByRawValue : NSObject <TyphoonInjectedParameter>

@property(nonatomic, readonly) NSUInteger index;
@property(nonatomic, readonly) TyphoonParameterInjectionType type;
@property(nonatomic, strong, readonly) id value;

- (id)initWithParameterIndex:(NSUInteger)index value:(id)value;


@end
