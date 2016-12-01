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

#import "TyphoonComponentFactory+Storyboard.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"

#import "TyphoonDefinition.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonStoryboard.h"
#import "TyphoonWeakComponentsPool.h"


@interface TyphoonComponentFactory (Private)

@property(nonatomic, strong) NSString *typhoonKey;

- (TyphoonDefinition *)definitionForKey:(NSString *)key;

- (void)loadIfNeeded;

- (id<TyphoonComponentsPool>)poolForDefinition:(TyphoonDefinition *)definition;

@end

@implementation TyphoonComponentFactory (Storyboard)

static const char *kStoryboardPool;

- (void)setStoryboardPool:(id<TyphoonComponentsPool>)storyboardsPool
{
    objc_setAssociatedObject(self, &kStoryboardPool, storyboardsPool, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<TyphoonComponentsPool>)storyboardPool
{
    id<TyphoonComponentsPool> pool = objc_getAssociatedObject(self, &kStoryboardPool);
    if (pool == nil) {
        @synchronized (self) {
            pool = [TyphoonWeakComponentsPool new];
            [self setStoryboardPool:pool];
        }
    }
    return pool;
}

- (id)scopeCachedViewControllerForInstance:(UIViewController *)instance typhoonKey:(NSString *)typhoonKey
{
    @synchronized (self) {
        [self loadIfNeeded];
        
        TyphoonDefinition *definition = [self definitionForInstance:instance typhoonKey:typhoonKey];
        return [self cachedInstanceForDefinition:definition];
    }
}

- (id)scopeCachedViewControllerForClass:(Class)viewControllerClass typhoonKey:(NSString *)typhoonKey {
    @synchronized (self) {
        [self loadIfNeeded];
        
        id cachedInstance = nil;
        TyphoonDefinition *keyDefinition = [self definitionForKey:typhoonKey];
        if (keyDefinition) {
            return [self cachedInstanceForDefinition:keyDefinition];
        }
        
        TyphoonDefinition *classDefinition = [self definitionForClass:viewControllerClass];
        if (classDefinition) {
            return [self cachedInstanceForDefinition:classDefinition];
        }
        
        return cachedInstance;
    }
}

- (TyphoonDefinition *)definitionForClass:(Class)viewControllerClass
{
    if (!viewControllerClass) {
        return nil;
    }
    TyphoonDefinition *definition = [self definitionForType:viewControllerClass orNil:YES includeSubclasses:NO];
    return definition;
}

- (TyphoonDefinition *)definitionForInstance:(UIViewController *)instance typhoonKey:(NSString *)typhoonKey
{
    TyphoonDefinition *definition;
    if (typhoonKey.length) {
        definition = [self definitionForKey:typhoonKey];
    }
    else {
        definition = [self definitionForType:[instance class] orNil:YES includeSubclasses:NO];
    }
    return definition;
}

- (id)cachedInstanceForDefinition:(TyphoonDefinition *)definition
{
    if (!definition) {
        return nil;
    }
    
    id<TyphoonComponentsPool> pool = [self poolForDefinition:definition];
    id cachedInstance = [pool objectForKey:definition.key];
    return cachedInstance;
}

@end
