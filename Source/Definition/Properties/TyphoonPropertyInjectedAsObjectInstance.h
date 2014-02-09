////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "TyphoonAbstractInjectedProperty.h"

/**
*/
@interface TyphoonPropertyInjectedAsObjectInstance : TyphoonAbstractInjectedProperty

@property(nonatomic, strong, readonly) id objectInstance;

- (id)initWithName:(NSString *)name objectInstance:(id)objectInstance;

@end
