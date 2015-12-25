////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "TyphoonDefinition.h"
#import "TyphoonInjectionEnumeration.h"

@interface TyphoonInjectionPrimitiveEncoder : NSObject

@property (nonatomic, assign, getter = isShifted) BOOL shifted;

- (unsigned char)encodeRuntimeArgumentIndex:(NSUInteger)index;
// TODO: encode config key

- (void)decodeInjectionEnumeration:(id<TyphoonInjectionEnumeration>)enumeration withBlock:(BOOL (^)(id<NSCopying> key, id decodedInjection))block;

@end


@interface TyphoonInjectionPrimitiveEncoder (ThreadLocal)

+ (instancetype)currentEncoder;

@end
