////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2014 ibipit
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of ibipit
//  Use is subject to license terms.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonAbstractInjectedParameter.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonInitializer.h"
#import "TyphoonInitializer+InstanceBuilder.h"
#import "TyphoonDefinition.h"
#import "TyphoonIntrospectionUtils.h"
#import "NSValue+TCFInstanceBuilder.h"

@implementation TyphoonAbstractInjectedParameter

- (id)copyWithZone:(NSZone *)zone
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
    return nil;
}

- (void)withFactory:(TyphoonComponentFactory *)factory setArgumentOnInvocation:(NSInvocation *)invocation
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (BOOL)isPrimitiveParameter
{
    BOOL isClass = [_initializer isClassMethod];
    Class class = [_initializer.definition type];

    NSArray *typeCodes = [TyphoonIntrospectionUtils typeCodesForSelector:_initializer.selector ofClass:class isClassMethod:isClass];

    return ![[typeCodes objectAtIndex:_index] isEqualToString:@"@"];
}

- (void)setObject:(id)object forInvocation:(NSInvocation *)invocation
{
    BOOL isObjectIsWrapper = [object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSValue class]];

    if (isObjectIsWrapper && [self isPrimitiveParameter]) {
        [object typhoon_setAsArgumentForInvocation:invocation atIndex:_index + 2];
    }
    else {
        [invocation setArgument:&object atIndex:_index + 2];
    }
}

@end