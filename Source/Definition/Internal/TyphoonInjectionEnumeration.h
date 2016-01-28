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


#import <Foundation/Foundation.h>

typedef void (^TyphoonInjectionsEnumerationBlock)(id injection, id *injectionToReplace, BOOL *stop);

typedef NS_OPTIONS(NSInteger, TyphoonInjectionsEnumerationOption) {
    TyphoonInjectionsEnumerationOptionProperties = 1 << 0,
    TyphoonInjectionsEnumerationOptionMethods = 1 << 2,
    TyphoonInjectionsEnumerationOptionAll = TyphoonInjectionsEnumerationOptionProperties | TyphoonInjectionsEnumerationOptionMethods,
};

@protocol TyphoonInjectionEnumeration <NSObject>

- (void)enumerateInjectionsOfKind:(Class)injectionClass options:(TyphoonInjectionsEnumerationOption)options
                       usingBlock:(TyphoonInjectionsEnumerationBlock)block;

@end
