////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////




#import <Foundation/Foundation.h>
#import "TyphoonInjectedParameter.h"

@class TyphoonTypeDescriptor;


@interface TyphoonParameterInjectedByValue : NSObject <TyphoonInjectedParameter>
{
    __unsafe_unretained TyphoonInitializer* _initializer;
}

@property(nonatomic, readonly) NSUInteger index;
@property(nonatomic, readonly) TyphoonParameterInjectionType type;
@property(nonatomic, strong) NSString* textValue;
@property(nonatomic, strong, readonly) Class requiredType;

- (id)initWithIndex:(NSUInteger)index value:(NSString*)value requiredTypeOrNil:(Class)requiredTypeOrNil;

/**
* If the parameter is a primitive type, resolves the type descriptor. Throws an exception if either:
* - requiredType is set
* - The parameter is an object type. (If the parameter is an object type, classOrProtocol must be set explicitly).
*/
- (TyphoonTypeDescriptor*)resolveTypeWith:(id)classOrInstance;

@end