////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "TyphoonResource.h"
#import "TyphoonInitializer.h"

@implementation TyphoonDefinition (Infrastructure)

+ (TyphoonDefinition *)propertyPlaceholderWithResource:(id<TyphoonResource>)resource {
  
    TyphoonDefinition *definition = [self withClass:[TyphoonPropertyPlaceholderConfigurer class] initialization:^(TyphoonInitializer *initializer) {
        
        initializer.selector = @selector(configurerWithResource:);
        [initializer injectWithObject:resource];
        
    }];
    definition.key = [NSString stringWithFormat:@"%@-%@", NSStringFromClass(definition.class), [resource description]];
    return definition;
}

@end
