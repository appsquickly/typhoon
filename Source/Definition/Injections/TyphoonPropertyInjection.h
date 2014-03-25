//
//  TyphoonPropertyInjection.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 11.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjection.h"

@protocol TyphoonPropertyInjection <TyphoonInjection>

- (void)setPropertyName:(NSString *)name;
- (NSString *)propertyName;

@end
