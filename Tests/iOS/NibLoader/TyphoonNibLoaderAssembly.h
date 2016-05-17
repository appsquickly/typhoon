////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Typhoon/Typhoon.h>

static NSString* const kTyphoonNibLoaderSpecifiedViewControllerIdentifier =     @"TyphoonNibLoaderSpecifiedViewController";
static NSString* const kTyphoonNibLoaderUnspecifiedViewControllerIdentifier =   @"TyphoonNibLoaderUnspecifiedViewController";
static NSString* const kTyphoonNibLoaderInexistentViewController =              @"TyphoonNibLoaderInexistentViewController";

@interface TyphoonNibLoaderAssembly : TyphoonAssembly

- (id)specifiedViewController;
- (id)unspecifiedViewController;

@end
