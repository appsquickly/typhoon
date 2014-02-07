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
#import "TyphoonInjectedAsCollection.h"

@class TyphoonDefinition;
@protocol TyphoonIntrospectiveNSObject;



/**
 * Represents a collection (NSArray, NSSet, c-style array) of items injected by reference, value or type.
 */
@interface TyphoonInjectedAsCollectionImpl : NSObject<TyphoonInjectedAsCollection>


@end
