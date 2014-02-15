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



#import "InvalidCollaboratingAssembly.h"
#import "MiddleAgesAssembly.h"
#import "Knight.h"
#import "TyphoonDefinition.h"

@implementation InvalidCollaboratingAssembly
{

}

- (id)knightWithExternalQuest {
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest) withDefinition:[[MiddleAgesAssembly assembly] environmentDependentQuest]];
    }];
}

@end