//
//  PrototypeAssembly.h
//  Typhoon
//
//  Created by Aleksey Garbarev on 28/05/2018.
//  Copyright © 2018 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Typhoon/Typhoon.h>
#import "Knight.h"
#import "King.h"

@interface PrototypeAssembly : TyphoonAssembly

- (Knight *)prototypeKnight;
- (Knight *)prototypeKnightWithFort;

- (King *)kingArthur;
- (King *)kingMordred;

@end
