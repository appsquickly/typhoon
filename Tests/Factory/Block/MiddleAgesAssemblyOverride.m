//
//  MiddleAgesAssemblyOverride.m
//  Typhoon
//
//  Created by Jose Gonzalez Gomez on 17/05/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "MiddleAgesAssemblyOverride.h"
#import "TyphoonDefinition.h"
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

@end
