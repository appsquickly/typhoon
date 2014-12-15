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


#import "TyphoonPropertyInjection.h"
#import "TyphoonParameterInjection.h"

@protocol TyphoonObjectWithCustomInjection <NSObject>

- (id <TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection;

@end
