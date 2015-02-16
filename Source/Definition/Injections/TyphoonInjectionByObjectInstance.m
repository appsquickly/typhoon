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

- (NSString *)customDescription
{
    return [NSString stringWithFormat:@"instanceClass = %@, ", [self.objectInstance class]];
}

@end
