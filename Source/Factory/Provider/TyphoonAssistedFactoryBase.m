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
#import "TyphoonPropertyInjection.h"

@implementation TyphoonAssistedFactoryBase
{
    NSMutableDictionary *_injections;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _injections = [[NSMutableDictionary alloc] init];
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
        return ((TyphoonPropertyInjectionLazyValue) [self injectionValueForProperty:property])();
    }
}

- (id)_dummyGetter
{
    return nil;
}

- (BOOL)shouldInjectProperty:(id <TyphoonPropertyInjection>)property withType:(TyphoonTypeDescriptor *)type lazyValue:(TyphoonPropertyInjectionLazyValue)lazyValue
{
    [_injections setObject:lazyValue forKey:property.propertyName];
    return NO;
}

@end
