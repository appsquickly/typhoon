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


@implementation TyphoonAbstractInjectedParameter

- (TyphoonParameterInjectionType)type
{
    [NSException raise:NSInternalInconsistencyException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
    return 0;
}


@end