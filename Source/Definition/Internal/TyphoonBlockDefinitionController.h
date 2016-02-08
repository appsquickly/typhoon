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


#import <Foundation/Foundation.h>

@class TyphoonBlockDefinition;
@class TyphoonInjectionContext;

typedef NS_ENUM(NSInteger, TyphoonBlockDefinitionRoute) {
    TyphoonBlockDefinitionRouteInvalid,
    TyphoonBlockDefinitionRouteConfiguration,
    TyphoonBlockDefinitionRouteInitializer,
    TyphoonBlockDefinitionRouteInjections
};

@interface TyphoonBlockDefinitionController : NSObject

+ (instancetype)currentController;

@property (nonatomic, assign, readonly) TyphoonBlockDefinitionRoute route;

@property (nonatomic, assign, readonly, getter = isBuildingInstance) BOOL buildingInstance;

@property (nonatomic, strong, readonly) TyphoonBlockDefinition *definition;

@property (nonatomic, strong, readonly) id instance;

@property (nonatomic, strong, readonly) TyphoonInjectionContext *injectionContext;

- (void)useConfigurationRouteWithinBlock:(void (^)())block;

- (void)useInitializerRouteWithDefinition:(TyphoonBlockDefinition *)definition
                         injectionContext:(TyphoonInjectionContext *)context
                              withinBlock:(void (^)())block;

- (void)useInjectionsRouteWithDefinition:(TyphoonBlockDefinition *)definition
                                instance:(id)instance
                        injectionContext:(TyphoonInjectionContext *)context
                             withinBlock:(void (^)())block;

@end
