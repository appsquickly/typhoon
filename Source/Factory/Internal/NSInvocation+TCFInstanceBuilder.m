////////////////////////////////////////////////////////////////////////////////
//
// TYPHOON FRAMEWORK
// Copyright 2014, Typhoon Framework Contributors
// All Rights Reserved.
//
// NOTICE: The authors permit you to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSInvocation+TCFInstanceBuilder.h"

#if __has_feature(objc_arc)
#error You have to disable ARC for this file
#endif


@implementation NSInvocation (TCFInstanceBuilder)

/** Returns YES if selector returns retained instance (not autoreleased) */
static BOOL typhoon_IsSelectorReturnsRetained(SEL selector) {
    // According to http://clang.llvm.org/docs/AutomaticReferenceCounting.html#method-families
    // for a selector to be in a given family, the selector must start with the
    // family name, ignoring underscore prefixes, and followed by a character
    // other than a lowercase letter.
    // Otherwise methods like [MYRhyme initialRhyme] or [Player newbieWithName:]
    // will match incorrectly.
    static NSRegularExpression *methodFamily = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSError *error = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wassign-enum"
        methodFamily = [[NSRegularExpression alloc] initWithPattern:@"^_*(init|new|copy|mutableCopy)($|[^a-z])" options:0 error:&error];
#pragma clang diagnostic pop

        if (!methodFamily) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[error localizedDescription]
                userInfo:[error userInfo]];
        }
    });

    NSString *selectorString = NSStringFromSelector(selector);
    NSUInteger numberOfMatches =
        [methodFamily numberOfMatchesInString:selectorString options:NSMatchingAnchored range:NSMakeRange(0, selectorString.length)];

    return numberOfMatches != 0;
}

- (id)typhoon_resultOfInvokingOn:(id)instanceOrClass NS_RETURNS_RETAINED
{
    id returnValue = nil;

    BOOL isReturnsRetained = typhoon_IsSelectorReturnsRetained([self selector]);
    [self invokeWithTarget:instanceOrClass];
    [self getReturnValue:&returnValue];
    if (!isReturnsRetained) {
        [returnValue retain]; /* Retain to take ownership on autoreleased object */
    }

    return returnValue;
}

- (id)typhoon_resultOfInvokingOnInstance:(id)instance
{
    return [self typhoon_resultOfInvokingOn:instance];
}

- (id)typhoon_resultOfInvokingOnAllocationForClass:(Class)aClass
{
    /* To static analyser warning:
     * 'firstlyCreatedInstance' is not leak. There is two cases:
     *   1) instance is firstlyCreatedInstance (have same pointer) - then we returning this as retained result
     *   2) instance is not firstlyCreatedInstance (have different pointer) - then 'init...' method responsible
     *   to release 'firstlyCreatedInstance'
     * But clang analyzer dont know this.. */

#ifndef __clang_analyzer__
    id firstlyCreatedInstance = [aClass alloc];
    return [self typhoon_resultOfInvokingOn:firstlyCreatedInstance];
#else
    return nil;
#endif
}


@end
