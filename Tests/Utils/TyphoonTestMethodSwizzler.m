//
// Created by Robert Gilliam on 12/14/13.
//

#import "TyphoonTestMethodSwizzler.h"
#import "TyphoonWrappedSelector.h"


@implementation TyphoonTestMethodSwizzler
{
    NSMutableDictionary* _exchangedPairsForClass;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _exchangedPairsForClass = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)assertExchangedImplementationsFor:(NSString*)methodA with:(NSString*)methodB onClass:(Class)pClass
{
    __block BOOL matched = NO;
    TyphoonWrappedSelector* wrappedMethodA = [TyphoonWrappedSelector wrappedSelectorWithName:methodA];
    TyphoonWrappedSelector* wrappedMethodB = [TyphoonWrappedSelector wrappedSelectorWithName:methodB];

    NSMutableArray* exchangedPairs = [_exchangedPairsForClass objectForKey:NSStringFromClass(pClass)];
    [exchangedPairs enumerateObjectsUsingBlock:^(NSArray* exchanged, NSUInteger idx, BOOL* stop)
    {
        matched = ([exchanged containsObject:wrappedMethodA] && [exchanged containsObject:wrappedMethodB]);
        if (matched) {
            *stop = YES;
        }
    }];

    if (!matched) {
        // Expected methodA: to be exchanged with methodB:, but exchanged pairs were: ()
        [NSException raise:NSInternalInconsistencyException format:@"Expected '%@' to be exchanged with '%@' on class '%@', but exchanged pairs for that class were '%@'.", methodA, methodB, NSStringFromClass(pClass), exchangedPairs];
    }
}

- (BOOL)swizzleMethod:(SEL)selA withMethod:(SEL)selB onClass:(Class)pClass error:(NSError**)error
{
    NSMutableArray* exchangedPairs = [_exchangedPairsForClass objectForKey:NSStringFromClass(pClass)];
    if (!exchangedPairs) {
        exchangedPairs = [[NSMutableArray alloc] init];
        [_exchangedPairsForClass setObject:exchangedPairs forKey:NSStringFromClass(pClass)];
    }

    NSMutableArray* exchanged = @[[TyphoonWrappedSelector wrappedSelectorWithSelector:selA], [TyphoonWrappedSelector wrappedSelectorWithSelector:selB]];
    [exchangedPairs addObject:exchanged];
    return YES;
}

@end