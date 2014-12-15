////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonTestMethodSwizzler.h"
#import "TyphoonSelector.h"


@implementation TyphoonTestMethodSwizzler
{
    NSMutableDictionary *_exchangedPairsForClass;
}

- (id)init
{
    self = [super init];
    if (self) {
        _exchangedPairsForClass = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)assertExchangedImplementationsFor:(NSString *)methodA with:(NSString *)methodB onClass:(Class)pClass
{
    __block BOOL matched = NO;
    TyphoonSelector *wrappedMethodA = [TyphoonSelector selectorWithName:methodA];
    TyphoonSelector *wrappedMethodB = [TyphoonSelector selectorWithName:methodB];

    NSMutableArray *exchangedPairs = [_exchangedPairsForClass objectForKey:NSStringFromClass(pClass)];
    [exchangedPairs enumerateObjectsUsingBlock:^(NSArray *exchanged, NSUInteger idx, BOOL *stop) {
        matched = ([exchanged containsObject:wrappedMethodA] && [exchanged containsObject:wrappedMethodB]);
        if (matched) {
            *stop = YES;
        }
    }];

    if (!matched) {
        [NSException raise:NSInternalInconsistencyException
            format:@"Expected '%@' to be exchanged with '%@' on class '%@', but exchanged pairs for that class were '%@'.", methodA,
                   methodB, NSStringFromClass(pClass), exchangedPairs];
    }
}

- (BOOL)swizzleMethod:(SEL)selA withMethod:(SEL)selB onClass:(Class)pClass error:(NSError **)error
{
    NSMutableArray *exchangedPairs = [_exchangedPairsForClass objectForKey:NSStringFromClass(pClass)];
    if (!exchangedPairs) {
        exchangedPairs = [[NSMutableArray alloc] init];
        [_exchangedPairsForClass setObject:exchangedPairs forKey:NSStringFromClass(pClass)];
    }

    NSArray *exchanged = @[
        [TyphoonSelector selectorWithSEL:selA],
        [TyphoonSelector selectorWithSEL:selB]
    ];
    [exchangedPairs addObject:exchanged];
    return YES;
}

@end