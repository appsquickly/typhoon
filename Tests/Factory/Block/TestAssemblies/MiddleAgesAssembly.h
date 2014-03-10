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



#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"
#import "QuestProvider.h"

@class TyphoonDefinition;


@interface MiddleAgesAssembly : TyphoonAssembly <QuestProvider>

- (id)knight;

- (id)cavalryMan;

- (id)defaultQuest;

- (id)environmentDependentQuest;

- (id)anotherKnight;

- (id)yetAnotherKnight;

- (id)serviceUrl;

- (id)knightWithRuntimeDamselsRescued:(NSNumber *)damselsRescued runtimeFoobar:(NSObject *)runtimeObject;

@end