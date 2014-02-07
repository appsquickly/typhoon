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


@implementation TyphoonAbstractInjectedParameter



- (void)withFactory:(TyphoonComponentFactory*)factory setArgumentOnInvocation:(NSInvocation*)invocation
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
}

@end