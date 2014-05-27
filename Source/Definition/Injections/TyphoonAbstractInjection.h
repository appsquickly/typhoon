//
//  TyphoonAbstractInjection.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 11.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonPropertyInjection.h"
#import "TyphoonParameterInjection.h"
#import "TyphoonInjectionContext.h"

typedef NS_ENUM(NSInteger, TyphoonInjectionType) {
    TyphoonInjectionTypeUndefinied,
    TyphoonInjectionTypeProperty,
    TyphoonInjectionTypeParameter
};

@interface TyphoonAbstractInjection : NSObject <TyphoonParameterInjection, TyphoonPropertyInjection>

@property(nonatomic, readonly) TyphoonInjectionType type;

/* TyphoonInjectionTypeProperty properties */
@property(nonatomic, readonly, strong) NSString *propertyName;

/* TyphoonInjectionTypeParameter properties */
@property(nonatomic, readonly) NSUInteger parameterIndex;


@end

@interface TyphoonAbstractInjection (Protected)

- (void)copyBasePropertiesTo:(TyphoonAbstractInjection *)copiedInjection;

@end
