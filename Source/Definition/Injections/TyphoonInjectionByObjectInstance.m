//
//  TyphoonInjectionByObjectInstance.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByObjectInstance.h"
#import "NSInvocation+TCFUnwrapValues.h"

@implementation TyphoonInjectionByObjectInstance

- (instancetype)initWithObjectInstance:(id)objectInstance
{
    self = [super init];
    if (self) {
        _objectInstance = objectInstance;
    }
    return self;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByObjectInstance *copied = [[TyphoonInjectionByObjectInstance alloc] initWithObjectInstance:self.objectInstance];
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (BOOL)isEqualToCustom:(TyphoonInjectionByObjectInstance *)injection
{
    return [self.objectInstance isEqual:injection.objectInstance];
}

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    result(_objectInstance);
}

- (NSUInteger)customHash
{
    return [_objectInstance hash];
}

@end
