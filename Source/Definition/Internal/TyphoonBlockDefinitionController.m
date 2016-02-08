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

#pragma mark - Thread-local Instance

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

#pragma mark - Public Methods

- (BOOL)isBuildingInstance {
    return _route == TyphoonBlockDefinitionRouteInitializer || _route == TyphoonBlockDefinitionRouteInjections;
}

- (void)useConfigurationRouteWithinBlock:(void (^)())block
{
    [self useRoute:TyphoonBlockDefinitionRouteConfiguration withinBlock:block];
}

- (void)useInitializerRouteWithDefinition:(TyphoonBlockDefinition *)definition
                         injectionContext:(TyphoonInjectionContext *)context
                              withinBlock:(void (^)())block
{
    _definition = definition;
    _injectionContext = context;
    
    [self useRoute:TyphoonBlockDefinitionRouteInitializer withinBlock:block];
}

- (void)useInjectionsRouteWithDefinition:(TyphoonBlockDefinition *)definition
                                instance:(id)instance
                        injectionContext:(TyphoonInjectionContext *)context
                             withinBlock:(void (^)())block
{
    _definition = definition;
    _instance = instance;
    _injectionContext = context;
    
    [self useRoute:TyphoonBlockDefinitionRouteInjections withinBlock:block];
}

#pragma mark - Private Methods

- (void)useRoute:(TyphoonBlockDefinitionRoute)route withinBlock:(void (^)())block
{
    _route = route;
    
    block();
    
    _route = TyphoonBlockDefinitionRouteInvalid;
    _definition = nil;
    _instance = nil;
    _injectionContext = nil;
}

@end
