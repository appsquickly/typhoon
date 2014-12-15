////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

/**
* Just drop this view into your Xib and specify definition key as restorationIdentifier
* This view will be dynamically replaced with view from definition at runtime.
* TyphoonLoadedView's frame, autoresizing mask and constraints would be transferred into view from definition
* */
@interface TyphoonLoadedView : UIView

@end
