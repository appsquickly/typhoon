////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonInitializer.h"
#import "TyphoonDefinition.h"
#import "TyphoonPropertyInjectedByType.h"
#import "TyphoonPropertyInjectedByReference.h"
#import "TyphoonPropertyInjectedByValue.h"
#import "TyphoonInitializer+InstanceBuilder.h"


@implementation TyphoonDefinition


/* ============================================================ Initializers ============================================================ */
- (id)initWithClass:(Class)clazz key:(NSString*)key factoryComponent:(NSString*)factoryComponent
{
    self = [super init];
    if (self)
    {
        _type = clazz;
        _key = [key copy];
        _factoryComponent = [factoryComponent copy];
        _injectedProperties = [[NSMutableSet alloc] init];
        [self validateRequiredParametersAreSet];
    }
    return self;
}

- (id)initWithClass:(Class)clazz key:(NSString*)key
{
    return [self initWithClass:clazz key:key factoryComponent:nil];
}

- (id)init
{
    return [self initWithClass:nil key:nil factoryComponent:nil];
}


/* ========================================================== Interface Methods ========================================================= */
- (void)injectProperty:(SEL)selector
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByType alloc] initWithName:NSStringFromSelector(selector)]];
}



- (void)injectProperty:(SEL)selector withValueAsText:(NSString*)textValue
{
    [_injectedProperties addObject:[[TyphoonPropertyInjectedByValue alloc] initWithName:NSStringFromSelector(selector) value:textValue]];
}

- (void)addInjectedProperty:(id <TyphoonInjectedProperty>)property
{
    [_injectedProperties addObject:property];
}

- (NSSet*)injectedProperties
{
    return [_injectedProperties copy];
}

- (void)setInitializer:(TyphoonInitializer*)initializer
{
    _initializer = initializer;
    [_initializer setComponentDefinition:self];
}




/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    return [NSString stringWithFormat:@"Definition: class='%@'", NSStringFromClass(_type)];
}

- (void)dealloc
{
    //Null out the __unsafe_unretained property on initializer
    [_initializer setComponentDefinition:nil];
}

/* ============================================================ Private Methods ========================================================= */
- (void)validateRequiredParametersAreSet
{
    if (_type == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Property 'clazz' is required."];
    }
}



@end