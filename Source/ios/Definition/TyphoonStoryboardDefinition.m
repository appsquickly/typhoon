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

#import "TyphoonStoryboardDefinition.h"

#import "TyphoonViewControllerFactory.h"
#import "TyphoonStoryboardDefinitionContext.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonAbstractInjection.h"
#import "TyphoonInjections.h"
#import "TyphoonDefinition+Infrastructure.h"

@interface TyphoonStoryboardDefinition ()

@property (strong, nonatomic) TyphoonStoryboardDefinitionContext *context;

@end

@implementation TyphoonStoryboardDefinition

@synthesize scope = _scope;

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    if (self.context.type == TyphoonStoryboardDefinitionByFactoryType) {
        return [super targetForInitializerWithFactory:factory args:args];
    }
    
    TyphoonInjectionContext *injectionContext = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args raiseExceptionIfCircular:YES];
    UIViewController *result = [TyphoonViewControllerFactory viewControllerWithStoryboardContext:self.context injectionContext:injectionContext factory:factory];
    return result;
}

- (id)initWithStoryboardName:(id)storyboardName viewControllerId:(id)viewControllerId
{
    if (!storyboardName) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Tried to instantiate ViewController with identifier %@ from the storyboard with unspecified name. This property cannot be nil.", viewControllerId];
    }
    self = [super initWithClass:[NSObject class] key:nil];
    if (self) {
        _context = [TyphoonStoryboardDefinitionContext contextWithStoryboardName:TyphoonMakeInjectionFromObjectIfNeeded(storyboardName)
                                                                viewControllerId:TyphoonMakeInjectionFromObjectIfNeeded(viewControllerId)];
        _scope = TyphoonScopePrototype;
    }
    return self;
}

- (id)initWithStoryboard:(UIStoryboard *)storyboard viewControllerId:(id)viewControllerId
{
    self = [super initWithFactory:storyboard
                         selector:@selector(instantiateViewControllerWithIdentifier:)
                       parameters:^(TyphoonMethod *method) {
                           [method injectParameterWith:TyphoonMakeInjectionFromObjectIfNeeded(viewControllerId)];
                       }];
    if (self) {
        _context = [TyphoonStoryboardDefinitionContext contextForPreconfiguredStoryboardWithViewControllerId:TyphoonMakeInjectionFromObjectIfNeeded(viewControllerId)];
    }
    return self;
}

- (TyphoonMethod *)initializer
{
    if (self.context.type == TyphoonStoryboardDefinitionByFactoryType) {
        return [super initializer];
    }
    return nil;
}

@end
