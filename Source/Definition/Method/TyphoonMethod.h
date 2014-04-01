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

/**
* @ingroup Definition
*
* Represents an initializer for a component.
*
* ##Initializer style injection has the following advantages:
*
* - Presents a clear contract to put the instance in the required state before use.
* - No custom lifecycle methods (before/after property injection) are required.
*
* ##Initializer injection has the following drawbacks:
*
* - Not suitable for classes with a very large number of dependencies - a very large initializer method will create poor readability.
* - Auto-injection by type is not supported.
* - No type introspection for objects injected with a text representation.
*
* Its generally recommended to use initializer-style injection, unless the above drawbacks will manifest.
*
*/
@interface TyphoonMethod : NSObject <NSCopying>
{
    NSMutableArray *_injectedParameters;
    NSArray *_parameterNames;
    SEL _selector;
}

/**
* The selector used to initialize the component.
*/
@property(nonatomic) SEL selector;

@property(nonatomic, readonly) NSArray *parameterNames;

- (id)initWithSelector:(SEL)selector;

/* ====================================================================================================================================== */
#pragma mark - inject

- (void)injectParameterWith:(id)injection;

- (void)injectParameter:(NSString *)parameterName with:(id)injection;


@end
