//
//  King.m
//  Typhoon
//
//  Created by Aleksey Garbarev on 28/05/2018.
//  Copyright © 2018 typhoonframework.org. All rights reserved.
//

#import "King.h"

@implementation King

- (void)setName:(NSString *)name
{
    _name = name;
    [self updateGuardsName];
}

- (void)setPersonalGuard:(Knight *)personalGuard
{
    _personalGuard = personalGuard;
    [self updateGuardsName];
}

- (void)updateGuardsName
{
    self.personalGuard.name = [NSString stringWithFormat:@"%@'s personal guard", self.name];
}

@end
