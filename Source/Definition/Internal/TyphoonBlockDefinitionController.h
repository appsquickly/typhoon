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

typedef NS_ENUM(NSInteger, TyphoonBlockDefinitionRoute) {
    TyphoonBlockDefinitionRouteInvalid,
    TyphoonBlockDefinitionRouteConfiguration,
    TyphoonBlockDefinitionRouteInitializer,
    TyphoonBlockDefinitionRouteInjections
};

@interface TyphoonBlockDefinitionController : NSObject

+ (instancetype)currentController;

@property (nonatomic, assign, readonly) TyphoonBlockDefinitionRoute route;

@property (nonatomic, strong, readonly) id instance;

- (void)setRoute:(TyphoonBlockDefinitionRoute)route instance:(id)instance withinBlock:(void (^)())block;

@end
