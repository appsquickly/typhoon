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
#import <UIKit/UIKit.h>

#import "TyphoonViewControllerNibResolver.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonMethod.h"
#import "TyphoonDefinition+Infrastructure.h"

@implementation TyphoonViewControllerNibResolver

#pragma mark - Protocol methods

- (void)postProcessDefinition:(TyphoonDefinition *)definition replacement:(TyphoonDefinition **)definitionToReplace withFactory:(TyphoonComponentFactory *)factory
{
    if ([self shouldProcessDefinition:definition]) {
        [self processViewControllerDefinition:definition];
    }
}

#pragma mark - Interface methods

- (NSString *)resolveNibNameForClass:(Class)viewControllerClass
{
    return NSStringFromClass(viewControllerClass);
}

//-------------------------------------------------------------------------------------------
#pragma mark - Private Methods

- (void)processViewControllerDefinition:(TyphoonDefinition *)definition
{
    [definition useInitializer:@selector(initWithNibName:bundle:) parameters:^(TyphoonMethod *initializer) {
        [initializer injectParameterWith:[self resolveNibNameForClass:definition.type]];
        [initializer injectParameterWith:[NSBundle mainBundle]];
    }];
}

- (BOOL)shouldProcessDefinition:(TyphoonDefinition *)definition
{
    return [definition.type isSubclassOfClass:[UIViewController class]] && definition.initializerGenerated;
}

@end
