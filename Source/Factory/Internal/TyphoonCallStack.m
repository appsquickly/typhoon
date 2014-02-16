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


#import "TyphoonCallStack.h"
#import "TyphoonStackElement.h"


@implementation TyphoonCallStack
{
    NSMutableArray *_storage;
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
    if (self) {
        _storage = [NSMutableArray array];
    }
    return self;
}


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)push:(TyphoonStackElement *)stackItem
{
    if (![stackItem isKindOfClass:[TyphoonStackElement class]]) {
        [NSException raise:NSInvalidArgumentException format:@"Not a TyphoonStackItem: %@", stackItem];
    }
    [_storage addObject:stackItem];
}

- (TyphoonStackElement *)pop
{
    id element = [_storage lastObject];
    if ([self isEmpty] == NO) {
        [_storage removeLastObject];
    }
    return element;
}


- (TyphoonStackElement *)peekForKey:(NSString *)key
{
    for (TyphoonStackElement *item in [_storage reverseObjectEnumerator]) {
        if ([item.key isEqualToString:key]) {
            return item;
        }
    }
    return nil;
}

- (BOOL)isEmpty
{
    return ([_storage count] == 0);
}

- (BOOL)isResolvingKey:(NSString *)key
{
    return [self peekForKey:key] != nil;
}

@end
