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

@interface TyphoonStoryboardDefinition ()

@property (strong, nonatomic) TyphoonStoryboardDefinitionContext *context;

@end

@implementation TyphoonStoryboardDefinition

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    if (self.context.type == TyphoonStoryboardDefinitionByFactoryType) {
        return [super targetForInitializerWithFactory:factory args:args];
    }
    
    TyphoonViewControllerFactory *viewControllerFactory = [[TyphoonViewControllerFactory alloc] initWithFactory:factory];
    UIViewController *result = [viewControllerFactory viewControllerWithStoryboardContext:self.context];
    return result;
}

- (id)initWithStoryboardName:(NSString *)storyboardName viewControllerId:(NSString *)viewControllerId
{
    self = [super initWithClass:[NSObject class] key:nil];
    if (self) {
        _context = [TyphoonStoryboardDefinitionContext contextWithStoryboardName:storyboardName
                                                                viewControllerId:viewControllerId];
        _scope = TyphoonScopePrototype;
    }
    return self;
}

- (id)initWithStoryboard:(UIStoryboard *)storyboard viewControllerId:(NSString *)viewControllerId
{
    self = [super initWithFactory:storyboard
                         selector:@selector(instantiateViewControllerWithIdentifier:)
                       parameters:^(TyphoonMethod *method) {
                           [method injectParameterWith:viewControllerId];
                       }];
    if (self) {
        _context = [TyphoonStoryboardDefinitionContext contextForPreconfiguredStoryboardWithViewControllerId:viewControllerId];
    }
    return self;
}

- (TyphoonMethod *)initializer {
    if (self.context.type == TyphoonStoryboardDefinitionByFactoryType) {
        return [super initializer];
    }
    return nil;
}

@end
