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


#import "TyphoonAbstractInjection.h"

@interface TyphoonInjectionByObjectFromString : TyphoonAbstractInjection

@property(nonatomic, strong) NSString *textValue;

- (instancetype)initWithString:(NSString *)string;

@end
