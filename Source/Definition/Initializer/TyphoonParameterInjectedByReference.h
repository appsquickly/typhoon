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
#import "TyphoonInjectedByReference.h"

/**
*/
@interface TyphoonParameterInjectedByReference : TyphoonInjectedByReference <TyphoonInjectedParameter>

@property(nonatomic, readonly) NSUInteger index;
@property(nonatomic, readonly) TyphoonParameterInjectionType type;

- (instancetype)initWithParameterIndex:(NSUInteger)parameterIndex reference:(NSString*)reference;
- (instancetype)initWithParameterIndex:(NSUInteger)index reference:(NSString *)reference fromCollaboratingAssemblyProxy:(BOOL)fromCollaboratingAssemblyProxy;


@end
