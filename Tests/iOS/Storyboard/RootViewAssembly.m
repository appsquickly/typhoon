//
//  RootViewAssembly.m
//  Typhoon
//
//  Created by Smal Vadim on 01/08/16.
//  Copyright © 2016 typhoonframework.org. All rights reserved.
//

#import "RootViewAssembly.h"
#import "LoadedView.h"
#import <UIKit/UIKit.h>

@implementation RootViewAssembly

- (UIView *)loadedView
{
    return [TyphoonDefinition withClass:[LoadedView class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(loadFromNib)];
                              [definition injectProperty:@selector(injectedValue)
                                                    with:@(1)];
                          }];
}

@end
