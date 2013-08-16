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

@class TyphoonDefinition;


@interface MiddleAgesAssembly : TyphoonAssembly

- (id)knight;

- (id)knightWithWeapon:(NSObject*)weapon;

- (id)cavalryMan;

- (id)defaultQuest;

- (id)anotherKnight;

- (id)yetAnotherKnight;

- (id)serviceUrl;

@end