//
//  TyphoonAbstractInjection.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 11.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonPropertyInjection.h"
#import "TyphoonParameterInjection.h"

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
@property(nonatomic, readonly, weak) TyphoonMethod *initializer;

@end

@interface TyphoonAbstractInjection (Protected)

- (void)copyBaseProperiesTo:(TyphoonAbstractInjection *)copiedInjection;

- (void)setObject:(id)object forType:(TyphoonTypeDescriptor *)type andInvocation:(NSInvocation *)invocation;

@end
