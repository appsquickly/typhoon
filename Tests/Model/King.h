//
//  King.h
//  Typhoon
//
//  Created by Aleksey Garbarev on 28/05/2018.
//  Copyright © 2018 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Knight.h"
#import "Kingdom.h"

@interface King : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) Knight *personalGuard;

@end
