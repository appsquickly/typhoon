////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "InvalidCollaboratingAssembly_Initializer.h"
#import "MiddleAgesAssembly.h"
#import "TyphoonDefinition.h"
#import "CavalryMan.h"
#import "TyphoonMethod.h"

@implementation InvalidCollaboratingAssembly_Initializer
{

}

- (id)knightWithExternalQuest
{
    return [TyphoonDefinition withClass:[CavalryMan class] initialization:^(TyphoonMethod *initializer) {
        initializer.selector = @selector(initWithQuest:);
        [initializer injectParameterWith:[[MiddleAgesAssembly assembly] environmentDependentQuest]];

    }];
}

@end