////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>

@class TyphoonAssembly;


@interface TyphoonAssemblyValidator : NSObject

@property (nonatomic, readonly) TyphoonAssembly *assembly;

- (instancetype)initWithAssembly:(TyphoonAssembly *)assembly;

- (void)validate;

@end


extern NSString const *TyphoonAssemblyInvalidException;