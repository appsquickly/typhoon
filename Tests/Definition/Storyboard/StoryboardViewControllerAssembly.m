//
//  StoryboardViewControllerAssembly.m
//  Tests
//
//  Created by Aleksey Garbarev on 25.02.14.
//
//

#import "StoryboardViewControllerAssembly.h"
#import "Typhoon.h"
#import "UniqueViewController.h"
#import <UIKit/UIKit.h>

@implementation StoryboardViewControllerAssembly

- (id) firstViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) withObjectInstance:@"First"];
    }];
}

- (id) secondViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) withObjectInstance:@"Second"];
    }];
}

- (id) uniqueViewController
{
    return [TyphoonDefinition withClass:[UniqueViewController class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) withObjectInstance:@"Unique"];
    }];
}

@end
