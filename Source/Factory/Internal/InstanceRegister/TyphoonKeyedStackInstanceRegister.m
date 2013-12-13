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



#import "TyphoonKeyedStackInstanceRegister.h"

#import "TyphoonGenericStack.h"


@implementation TyphoonKeyedStackInstanceRegister
{
    NSMutableDictionary* _registry;
}


#pragma mark Initialization

+ (instancetype)instanceRegister
{
    return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _registry = [NSMutableDictionary dictionary];
    }
    return self;
}


#pragma mark Public API

- (void)stashInstance:(id)instance forKey:(NSString*)key
{
    TyphoonGenericStack* stack = [self stackForKey:key];
    [stack push:instance];
}

- (id)unstashInstanceForKey:(NSString*)key
{
    TyphoonGenericStack* stack = _registry[key];
    return [stack pop];
}

- (id)peekInstanceForKey:(NSString*)key
{
    TyphoonGenericStack* stack = _registry[key];
    return [stack peek];
}

- (BOOL)hasInstanceForKey:(NSString*)key
{
    return ((_registry[key] != nil)&&([_registry[key] isEmpty] == NO));
}


#pragma mark Private methods

- (TyphoonGenericStack*)stackForKey:(NSString*)key
{
    TyphoonGenericStack* stack = _registry[key];

    if (!stack)
    {
        stack = [TyphoonGenericStack stack];
        _registry[key] = stack;
    }

    return stack;
}

@end
