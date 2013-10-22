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


@interface TyphoonParameterInjectedByReference : NSObject <TyphoonInjectedParameter>

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) TyphoonParameterInjectionType type;
@property (nonatomic, strong, readonly) NSString* reference;

- (id)initWithParameterIndex:(NSUInteger)parameterIndex reference:(NSString*)reference;


@end
