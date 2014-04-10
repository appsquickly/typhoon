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

- (id)initialViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"Initial"];
    }];
}

- (id)firstViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"First"];
    }];
}

- (id)secondViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"Second"];
    }];
}

- (id)uniqueViewController
{
    return [TyphoonDefinition withClass:[UniqueViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(title) with:@"Unique"];
    }];
}

@end
