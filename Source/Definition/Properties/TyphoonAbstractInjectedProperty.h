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
#import "TyphoonIntrospectiveNSObject.h"

@class TyphoonComponentFactory;

/**
* Provides a contract for typhoon injected properties (name, injectionType) as well as defines the notion of equality, based on name.
*/
@interface TyphoonAbstractInjectedProperty : NSObject <NSCopying>
{
    NSString *_name;
}

@property(nonatomic, strong) NSString *name;

- (id)withFactory:(TyphoonComponentFactory *)factory computeValueToInjectOnInstance:(id)instance;


@end
