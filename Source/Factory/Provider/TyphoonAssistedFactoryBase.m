////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonAssistedFactoryBase.h"

#import "TyphoonAbstractInjectedProperty.h"

@implementation TyphoonAssistedFactoryBase
{
    NSMutableDictionary *_injections;
    NSMutableDictionary *_values;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _injections = [[NSMutableDictionary alloc] init];
        _values = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (id)injectionValueForProperty:(NSString *)property
{
    return [_injections objectForKey:property];
}

- (id)dependencyValueForProperty:(NSString *)property
{
    @synchronized (self) {
        id value = [_values objectForKey:property];

        if (!value) {
            value = ((TyphoonPropertyInjectionLazyValue) [self injectionValueForProperty:property])();
            [_values setObject:value forKey:property];
        }

        return value;
    }
}

- (void)setDependencyValue:(id)value forProperty:(NSString *)property
{
    @synchronized (self) {
        [_values setObject:value forKey:property];
    }
}

- (id)_dummyGetter
{
    return nil;
}

- (void)_setDummySetter:(id)value
{
}

- (BOOL)shouldInjectProperty:(TyphoonAbstractInjectedProperty *)property withType:(TyphoonTypeDescriptor *)type
    lazyValue:(TyphoonPropertyInjectionLazyValue)lazyValue
{
    [_injections setObject:lazyValue forKey:property.name];
    return NO;
}

@end
