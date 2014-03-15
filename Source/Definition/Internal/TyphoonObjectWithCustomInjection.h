//
//  TyphoonObjectWithCustomInjection.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonPropertyInjection.h"
#import "TyphoonParameterInjection.h"

@protocol TyphoonObjectWithCustomInjection <NSObject>

- (id <TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection;

@end
