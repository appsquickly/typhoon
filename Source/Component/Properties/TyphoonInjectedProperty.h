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

typedef enum
{
    TyphoonPropertyInjectionTypeByReference,
    TyphoonPropertyInjectionTypeByType,
    TyphoonPropertyInjectionTypeAsStringRepresentation,
    TyphoonPropertyInjectionTypeAsObjectInstance,
    TyphoonPropertyInjectionTypeAsCollection
} TyphoonPropertyInjectionType;

@protocol TyphoonInjectedProperty <NSObject>

- (NSString*)name;

- (TyphoonPropertyInjectionType)injectionType;

@end
