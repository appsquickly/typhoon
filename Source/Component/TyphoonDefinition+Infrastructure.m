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

+ (NSString *)generateInfrastructureComponentKey {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *UUID = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    return UUID;
}

+ (TyphoonDefinition *)propertyPlaceholderWithResource:(id<TyphoonResource>)resource {
  
    TyphoonDefinition *definition = [self withClass:[TyphoonPropertyPlaceholderConfigurer class] initialization:^(TyphoonInitializer *initializer) {
        
        initializer.selector = @selector(configurerWithResource:);
        [initializer injectWithObject:resource];
        
    }];
    definition.key = [self generateInfrastructureComponentKey];
    return definition;
}

@end
