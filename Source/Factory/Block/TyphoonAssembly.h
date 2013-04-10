////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2013 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>


static NSString * const TYPHOON_BEFORE_ADVICE_SUFFIX = @"__typhoonBeforeAdvice";

@interface TyphoonAssembly : NSObject
{
    NSMutableDictionary* _cachedDefinitions;
}

+(TyphoonAssembly*)assembly;

/**
* Returns the [TyphoonComponentFactory defaultFactory], with components exposed using an assembly interface.
*/
+(TyphoonAssembly*)defaultAssembly;


@end