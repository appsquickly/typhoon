////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIView+TyphoonDefinitionKey.h"

#import <objc/runtime.h>

@implementation UIView (TyphoonDefinitionKey)

static const char *kTyphoonKey;

- (void)setTyphoonKey:(NSString *)typhoonKey
{
    objc_setAssociatedObject(self, &kTyphoonKey, typhoonKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)typhoonKey
{
    return objc_getAssociatedObject(self, &kTyphoonKey);
}

@end
