////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonNibLoaderAssembly.h"

#import "TyphoonNibLoaderSpecifiedViewController.h"

@implementation TyphoonNibLoaderAssembly

- (id)specifiedViewController
{
    return [TyphoonDefinition withClass:[TyphoonNibLoaderSpecifiedViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithNibName:bundle:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:kTyphoonNibLoaderSpecifiedViewControllerIdentifier];
            [initializer injectParameterWith:[NSBundle bundleForClass:[TyphoonBundleResource class]]];
        }];
        [definition injectProperty:@selector(title) with:@"Specified"];
        [definition injectProperty:@selector(specifiedTitle) with:@"Specified"];
    }];
}

- (id)unspecifiedViewController
{
    return [TyphoonDefinition withClass:[UIViewController class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithNibName:bundle:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:kTyphoonNibLoaderUnspecifiedViewControllerIdentifier];
            [initializer injectParameterWith:[NSBundle bundleForClass:[TyphoonBundleResource class]]];
        }];
        [definition injectProperty:@selector(title) with:@"Unspecified"];
    }];
}

@end
