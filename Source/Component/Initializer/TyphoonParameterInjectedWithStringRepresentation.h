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
#import "TyphoonInjectedParameter.h"
#import "TyphoonComponentInjectedByValue.h"

@class TyphoonTypeDescriptor;

/**
* Represents a parameter injected with a string representation. The type converter system will convert the representation to an instance of
* the required type.
*
* @see TyphoonPropertyPlaceholderConfigurer
*
*/
@interface TyphoonParameterInjectedWithStringRepresentation : NSObject <TyphoonInjectedParameter, TyphoonComponentInjectedByValue>
{
    __unsafe_unretained TyphoonInitializer* _initializer;
}

@property(nonatomic, readonly) NSUInteger index;
@property(nonatomic, readonly) TyphoonParameterInjectionType type;
@property(nonatomic, strong, readonly) Class requiredType;

- (id)initWithIndex:(NSUInteger)index value:(NSString*)value requiredTypeOrNil:(Class)requiredTypeOrNil;

/**
* If the parameter is a primitive type, resolves the type descriptor. Throws an exception if either:
* - requiredType is set
* - The parameter is an object type. (If the parameter is an object type, classOrProtocol must be set explicitly).
*/
- (TyphoonTypeDescriptor*)resolveTypeWith:(id)classOrInstance;

@end