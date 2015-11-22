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

- (id)initWithStoryboardName:(NSString *)storyboardName storyboardId:(NSString *)storyboardId
{
    self = [super initWithClass:[NSObject class] key:nil];
    if (self) {
        _context = [TyphoonStoryboardDefinitionContext contextWithStoryboardName:storyboardName
                                                                    storyboardId:storyboardId];
        _scope = TyphoonScopePrototype;
    }
    return self;
}

- (id)initWithStoryboard:(UIStoryboard *)storyboard storyboardId:(NSString *)storyboardId
{
    self = [super initWithFactory:storyboard
                         selector:@selector(instantiateViewControllerWithIdentifier:)
                       parameters:^(TyphoonMethod *method) {
                           [method injectParameterWith:storyboardId];
                       }];
    if (self) {
        _context = [TyphoonStoryboardDefinitionContext contextForPreconfiguredStoryboardWithStoryboardId:storyboardId];
    }
    return self;
}

@end
