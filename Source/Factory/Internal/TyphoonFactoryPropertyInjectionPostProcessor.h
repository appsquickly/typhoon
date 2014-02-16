//
//  TyphoonFactoryPropertyInjectionPostProcessor.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 16.02.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TyphoonComponentFactoryPostProcessor.h"
#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonDefinition.h"

@interface TyphoonFactoryPropertyInjectionPostProcessor : NSObject <TyphoonComponentFactoryPostProcessor>

/* Method to override in subclasses */
- (BOOL) shouldReplaceInjectionByType:(TyphoonPropertyInjectedByType *)propertyInjection withFactoryInjectionInDefinition:(TyphoonDefinition *)definition;

@end
