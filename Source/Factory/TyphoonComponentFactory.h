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
#import "TyphoonComponentFactoryMutator.h"
@class TyphoonDefinition;

/**
* This is the base class for for all spring component factories. Although, it could be used as-is, the intention is to use a
* sub-class like TyphoonXmlComponentFactory.
*/
@interface TyphoonComponentFactory : NSObject
{
    NSMutableArray* _registry;
    NSMutableDictionary* _singletons;

    NSMutableDictionary* _currentlyResolvingReferences;
    NSMutableArray* _mutators;
	BOOL _isLoading;
}

/**
* The instantiated singletons.
*/
@property (nonatomic, strong, readonly) NSArray *singletons;

/**
* Say if the factory has been loaded.
*/
@property (nonatomic, assign, getter = isLoaded) BOOL loaded;

/**
* Mutate the component definitions with the mutators and
* build the not-lazy singletons.
*/
- (void)load;

/**
* Dump all the singletons.
*/
- (void)unload;

/**
* Returns the default component factory, if one has been set. (See makeDefault ).
*/
+ (id)defaultFactory;


/**
* Sets a given instance of TyphoonComponentFactory, as the default factory so that it can be retrieved later with:

        [TyphoonComponentFactory defaultFactory];

*/
- (void)makeDefault;

/**
* Registers a component into the factory. Components can be declared in any order, the container will work out how to resolve them.
*/
- (void) register:(TyphoonDefinition*)definition;

/**
* Returns an an instance of the component matching the supplied class or protocol. For example:

        [factory objectForType:[Knight class]];
        [factory objectForType:@protocol(Quest)];

* @exception NSInvalidArgumentException When no singletons or prototypes match the requested type.
* @exception NSInvalidArgumentException When when more than one singleton or prototype matches the requested type.
*
* @See: allComponentsForType:
*/
- (id)componentForType:(id)classOrProtocol;

 - (NSArray*)allComponentsForType:(id)classOrProtocol;

- (id)componentForKey:(NSString*)key;

- (NSArray*)registry;

- (void)attachMutator:(id<TyphoonComponentFactoryMutator>)mutator;

/**
 * Injects the properties of an object
 */
- (void)injectProperties:(id)instance;

@end