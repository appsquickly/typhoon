//
//  TyphoonPropertyInjection.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 11.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

@class TyphoonComponentFactory;
@class TyphoonRuntimeArguments;

@protocol TyphoonPropertyInjection <NSObject, NSCopying>

- (void)setPropertyName:(NSString *)name;

- (NSString *)propertyName;

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args;

@end
