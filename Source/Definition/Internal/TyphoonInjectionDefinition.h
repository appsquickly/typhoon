////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOONFRAMEWORK.ORG
//  Copyright 2015 typhoonframework.org Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of typhoonframework.org. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import "TyphoonInjection.h"

@interface TyphoonInjectionDefinition : TyphoonDefinition

- (instancetype)initWithInjection:(id<TyphoonInjection>)injection;

@end
