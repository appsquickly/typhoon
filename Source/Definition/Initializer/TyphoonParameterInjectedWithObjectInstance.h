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
#import "TyphoonAbstractInjectedParameter.h"

/**
* Represents a parameter injected with an instance of an object - something constructed outside of the container.
*/
@interface TyphoonParameterInjectedWithObjectInstance : TyphoonAbstractInjectedParameter

@property(nonatomic, strong, readonly) id value;

- (id)initWithParameterIndex:(NSUInteger)index value:(id)value;

@end
