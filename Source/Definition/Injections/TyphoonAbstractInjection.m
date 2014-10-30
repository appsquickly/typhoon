//
//  TyphoonAbstractInjection.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 11.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAbstractInjection.h"
#import "TyphoonMethod+InstanceBuilder.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonUtils.h"


@implementation TyphoonAbstractInjection


- (NSString *)description
{
    if (self.type == TyphoonInjectionTypeUndefinied) {
        return [NSString stringWithFormat:@"<%@: %p, type=Undifined>", [self class], self];
    }
    else if (self.type == TyphoonInjectionTypeParameter) {
        return [NSString stringWithFormat:@"<%@: %p, index=%d>", [self class], self, (int) self.parameterIndex];
    }
    else {
        return [NSString stringWithFormat:@"<%@: %p, property=%@>", [self class], self, self.propertyName];
    }
}

- (void)setParameterIndex:(NSUInteger)index
{
    NSAssert(self.type != TyphoonInjectionTypeProperty, @"Trying to redefine injection with type %d", (int) self.type);
    _parameterIndex = index;
    _type = TyphoonInjectionTypeParameter;
}

- (void)setPropertyName:(NSString *)name
{
    NSAssert(self.type != TyphoonInjectionTypeParameter, @"Trying to redefine injection with type %d", (int) self.type);
    _propertyName = name;
    _type = TyphoonInjectionTypeProperty;
}

- (NSUInteger)hash
{
    NSUInteger hash = self.type;

    if (self.type == TyphoonInjectionTypeProperty) {
        hash = TyphoonHashByAppendingInteger(hash, [self.propertyName hash]);
    }
    else {
        hash = TyphoonHashByAppendingInteger(hash, self.parameterIndex);
    }

    return TyphoonHashByAppendingInteger(hash, [self customHash]);
}

- (NSUInteger)customHash
{
    /** Any constant can be here, nothing magical */
    return 25042013;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    return [self isEqualToBase:other] && [self isEqualToCustom:other];
}

- (BOOL)isEqualToBase:(TyphoonAbstractInjection *)base
{
    if (self == base) {
        return YES;
    }
    if (base == nil) {
        return NO;
    }

    if (self.type != base.type) {
        return NO;
    }

    if (self.type == TyphoonInjectionTypeParameter) {
        return self.parameterIndex == base.parameterIndex;
    }
    else if (self.type == TyphoonInjectionTypeProperty) {
        return [self.propertyName isEqualToString:base.propertyName];
    }
    else {
        return NO;
    }
}


#pragma mark - Methods to override

- (BOOL)isEqualToCustom:(id)injection
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
    return NO;
}

- (id)copyWithZone:(NSZone *)zone
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
    return nil;
}

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
}

@end

@implementation TyphoonAbstractInjection (Protected)

- (void)copyBasePropertiesTo:(TyphoonAbstractInjection *)copiedInjection
{
    if (self.type == TyphoonInjectionTypeProperty) {
        [copiedInjection setPropertyName:_propertyName];
    }
    else if (self.type == TyphoonInjectionTypeParameter) {
        [copiedInjection setParameterIndex:_parameterIndex];
    }
}

@end
