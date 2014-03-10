//
//  TyphoonPropertyInjectedWithRuntimeArg.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 10.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAbstractInjectedProperty.h"

@interface TyphoonPropertyInjectedWithRuntimeArg : TyphoonAbstractInjectedProperty

@property (nonatomic) NSUInteger index;

/* index is zero-based */
- (instancetype)initWithArgumentIndex:(NSUInteger)index;

@end
