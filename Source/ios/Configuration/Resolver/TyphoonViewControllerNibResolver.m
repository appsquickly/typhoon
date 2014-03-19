////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonViewControllerNibResolver.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonMethod.h"

@implementation TyphoonViewControllerNibResolver

#pragma mark - Protocol methods

- (void)postProcessComponentFactory:(TyphoonComponentFactory *)factory
{
    for (TyphoonDefinition *definition in [factory registry]) {
        if ([self shouldProcessDefinition:definition]) {
            [self processViewControllerDefinition:definition];
        }
    }
}

#pragma mark - Interface methods

- (NSString *)resolveNibNameForClass:(Class)viewControllerClass
{
    return NSStringFromClass(viewControllerClass);
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)processViewControllerDefinition:(TyphoonDefinition *)definition
{
    TyphoonMethod *initializer = [[TyphoonMethod alloc] initWithSelector:@selector(initWithNibName:bundle:)];
    [initializer injectParameterWith:[self resolveNibNameForClass:definition.type]];
    [initializer injectParameterWith:[NSBundle mainBundle]];
    definition.initializer = initializer;
}

- (BOOL)shouldProcessDefinition:(TyphoonDefinition *)definition
{
    return [definition.type isSubclassOfClass:[UIViewController class]] && definition.initializerGenerated;
}

@end
