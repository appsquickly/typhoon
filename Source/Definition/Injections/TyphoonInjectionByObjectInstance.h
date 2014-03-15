//
//  TyphoonInjectionByObjectInstance.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAbstractInjection.h"

@interface TyphoonInjectionByObjectInstance : TyphoonAbstractInjection

@property(nonatomic, strong, readonly) id objectInstance;

- (instancetype)initWithObjectInstance:(id)objectInstance;

@end
