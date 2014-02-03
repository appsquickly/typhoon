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
    NSMutableDictionary* _injections;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _injections = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (id)injectionValueForProperty:(NSString*)property
{
    return [_injections objectForKey:property];
}

- (id)_dummyGetter
{
    return nil;
}

- (void)_setDummySetter:(id)value
{
}

- (BOOL)shouldInjectProperty:(TyphoonAbstractInjectedProperty*)property withType:(TyphoonTypeDescriptor*)type
    lazyValue:(TyphoonPropertyInjectionLazyValue)lazyValue
{
    [_injections setObject:lazyValue forKey:property.name];
    return NO;
}

@end
