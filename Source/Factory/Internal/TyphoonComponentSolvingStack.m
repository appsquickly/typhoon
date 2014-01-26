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


#import "TyphoonComponentSolvingStack.h"
#import "TyphoonStackItem.h"
#import "TyphoonDefinition.h"
#import "OCLogTemplate.h"

@implementation TyphoonComponentSolvingStack
{
    NSMutableArray* _storage;
}


/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (instancetype)stack
{
    return [[self alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self)
    {
        _storage = [NSMutableArray array];
    }
    return self;
}


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)push:(TyphoonStackItem*)stackItem
{
    if (![stackItem isKindOfClass:[TyphoonStackItem class]])
    {
        [NSException raise:NSInvalidArgumentException format:@"Not a TyphoonStackItem: %@", stackItem];
    }
    if ([self itemForKey:stackItem.definition.key])
    {
        LogDebug(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ already in!!!!!!!!!!");
        return;
    }
    [_storage addObject:stackItem];
}

- (TyphoonStackItem*)pop
{
    id element = [_storage lastObject];
    if ([self isEmpty] == NO)
    {
        [_storage removeLastObject];
    }
    return element;
}

- (TyphoonStackItem*)peek
{
    return [_storage lastObject];
}

- (TyphoonStackItem*)itemForKey:(NSString*)key
{
    for (TyphoonStackItem* item in _storage)
    {
        if ([item.definition.key isEqualToString:key])
        {
            return item;
        }
    }
    return nil;
}


- (BOOL)isEmpty
{
    return ([_storage count] == 0);
}

@end
