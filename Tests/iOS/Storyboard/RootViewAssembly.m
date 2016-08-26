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
