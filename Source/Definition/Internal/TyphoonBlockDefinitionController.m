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


#import "TyphoonBlockDefinitionController.h"

static NSString * const kThreadDictionaryKey = @"org.typhoonframework.blockDefinitionController";

@implementation TyphoonBlockDefinitionController

+ (instancetype)currentController
{
    NSMutableDictionary *threadDictionary = [NSThread currentThread].threadDictionary;
    TyphoonBlockDefinitionController *controller = threadDictionary[kThreadDictionaryKey];
    if (!controller) {
        controller = [[TyphoonBlockDefinitionController alloc] init];
        threadDictionary[kThreadDictionaryKey] = controller;
    }
    return controller;
}

@end
