//
//  MiddleAgesAssemblyOverride.m
//  Typhoon
//
//  Created by Jose Gonzalez Gomez on 17/05/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "MiddleAgesAssemblyOverride.h"
#import "TyphoonDefinition.h"
#import "TyphoonInitializer.h"
#import "Knight.h"


@implementation MiddleAgesAssemblyOverride

- (id)knight
{
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
            {
                [definition injectProperty:@selector(quest) withDefinition:[self defaultQuest]];
                [definition injectProperty:@selector(damselsRescued) withValueAsText:@"50"]; // different from parent assembly definition
                [definition setScope:TyphoonScopeDefault];
            }];
}

- (id)testString
{
    return [TyphoonDefinition withClass:[NSDictionary class] initialization:^(TyphoonInitializer* initializer)
            {
                initializer.selector = @selector(initWithDictionary:);
                [initializer injectParameterWithValue:@{@"test": @123}];
            }];

}

@end
