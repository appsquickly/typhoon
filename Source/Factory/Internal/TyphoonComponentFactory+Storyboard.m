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

#import "TyphoonDefinition.h"
#import "TyphoonStoryboard.h"

@interface TyphoonComponentFactory (Private)

- (TyphoonDefinition *)definitionForKey:(NSString *)key;

- (void)loadIfNeeded;

- (id<TyphoonComponentsPool>)poolForDefinition:(TyphoonDefinition *)definition;

@end

@implementation TyphoonComponentFactory (Storyboard)


- (id)scopeCachedViewControllerForInstance:(UIViewController *)instance typhoonKey:(NSString *)typhoonKey
{
    @synchronized (self) {
        [self loadIfNeeded];
        
        id cachedInstance = nil;
        TyphoonDefinition *definition = [self definitionForInstance:instance typhoonKey:typhoonKey];
        
        if (definition) {
            id<TyphoonComponentsPool> pool = [self poolForDefinition:definition];
            cachedInstance = [pool objectForKey:typhoonKey];
        }
        
        return cachedInstance;
    }
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

@end
