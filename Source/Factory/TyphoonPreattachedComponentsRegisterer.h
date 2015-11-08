////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@class TyphoonComponentFactory;
@class TyphoonAssembly;

@interface TyphoonPreattachedComponentsRegisterer : NSObject

- (instancetype)initWithComponentFactory:(TyphoonComponentFactory *)componentFactory;

- (void)doRegistrationForAssembly:(TyphoonAssembly *)assembly;

@end
