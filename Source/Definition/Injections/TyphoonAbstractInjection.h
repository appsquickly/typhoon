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

- (BOOL)isEqualToCustom:(id)injection;
- (NSUInteger)customHash;

- (NSString *)customDescription;

@end

@interface TyphoonAbstractInjection (Protected)

- (void)copyBasePropertiesTo:(TyphoonAbstractInjection *)copiedInjection;

@end
