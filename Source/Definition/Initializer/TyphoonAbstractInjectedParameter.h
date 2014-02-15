////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2014 ibipit
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of ibipit
//  Use is subject to license terms.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@class TyphoonInitializer;
@class TyphoonComponentFactory;


@interface TyphoonAbstractInjectedParameter : NSObject <NSCopying>
{
    NSUInteger _index;
    __weak TyphoonInitializer *_initializer;
}

@property(nonatomic, readonly) NSUInteger index;
@property(nonatomic, weak) TyphoonInitializer *initializer;


- (void)withFactory:(TyphoonComponentFactory *)factory setArgumentOnInvocation:(NSInvocation *)invocation;


- (BOOL)isPrimitiveParameter;

- (void)setObject:(id)object forInvocation:(NSInvocation *)invocation;

@end