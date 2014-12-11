//
// Created by Aleksey Garbarev on 11.12.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>

IB_DESIGNABLE

#ifdef __IPHONE_6_1

/**
* Just drop this view into your Xib and specify definition key as restorationIdentifier
* This view will be dynamically replaced with view from definition at runtime.
* TyphoonLoadedView's frame, autoresizing mask and constraints would be transferred into view from definition
* */
@interface TyphoonLoadedView : UIView

@end

#endif