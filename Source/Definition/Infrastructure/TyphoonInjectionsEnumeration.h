////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


typedef void (^TyphoonInjectionsEnumerationBlock)(id injection, id *injectionToReplace, BOOL *stop);

typedef NS_OPTIONS(NSInteger, TyphoonInjectionsEnumerationOption) {
    TyphoonInjectionsEnumerationOptionProperties = 1 << 0,
    TyphoonInjectionsEnumerationOptionMethods = 1 << 2,
    TyphoonInjectionsEnumerationOptionAll = TyphoonInjectionsEnumerationOptionProperties | TyphoonInjectionsEnumerationOptionMethods,
};
