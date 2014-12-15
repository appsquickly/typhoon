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


#import "TyphoonInjectionContext.h"

@protocol TyphoonInjection <NSObject, NSCopying>

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result;

@end
