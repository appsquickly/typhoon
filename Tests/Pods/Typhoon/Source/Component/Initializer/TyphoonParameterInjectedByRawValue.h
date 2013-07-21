//
//  TyphoonParameterInjectedByRowValue.h
//  Typhoon
//
//  Created by Иван Ушаков on 23.05.13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonInjectedParameter.h"

@interface TyphoonParameterInjectedByRawValue : NSObject <TyphoonInjectedParameter>

@property(nonatomic, readonly) NSUInteger index;
@property(nonatomic, readonly) TyphoonParameterInjectionType type;
@property(nonatomic, strong, readonly) id value;

- (id)initWithParameterIndex:(NSUInteger)index value:(id)value;


@end
