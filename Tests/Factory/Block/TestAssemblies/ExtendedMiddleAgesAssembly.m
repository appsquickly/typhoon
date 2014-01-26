////////////////////////////////////////////////////////////////////////////////
//
//  58 NORTH
//  Copyright 2013 58 North
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of 58 North
//  Use is subject to license terms.
//
////////////////////////////////////////////////////////////////////////////////

#import "ExtendedMiddleAgesAssembly.h"
#import "Knight.h"
#import "TyphoonDefinition+Infrastructure.h"


@implementation ExtendedMiddleAgesAssembly

- (id)yetAnotherKnight
{
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        [definition injectProperty:@selector(damselsRescued) withValueAsText:@"296000"];
    }];
}


@end