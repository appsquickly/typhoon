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



#import <Foundation/Foundation.h>

@class Sword;


@interface SwordFactory : NSObject

- (Sword *)swordWithSpecification:(NSString *)swordSpecs;

- (Sword *)swordWithSpecification:(NSString *)swordSpec error:(NSError *__autoreleasing*)error;

@end