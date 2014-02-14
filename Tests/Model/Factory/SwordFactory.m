////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2012 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////




#import "SwordFactory.h"
#import "Sword.h"

@implementation SwordFactory

- (Sword *)swordWithSpecification:(NSString *)swordSpecs {
    if ([swordSpecs isEqualToString:@"blue"]) {
        return [[Sword alloc] initWithSpecification:@"A bright blue sword with orange pom-poms at the hilt."];
    }
    else {
        NSLog(@"Out of stock. Returning regular sword");
        return [[Sword alloc] initWithSpecification:@"Yer typical run-o-the-mill rusty sword."];
    }
}


@end