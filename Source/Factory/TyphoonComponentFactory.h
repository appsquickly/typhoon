////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "TyphoonDefinitionPostProcessor.h"
#import "TyphoonInstancePostProcessor.h"
#import "TyphoonTypeConverter.h"
#import "TyphoonComponentsPool.h"

@class TyphoonDefinition;
@class TyphoonCallStack;
@class TyphoonRuntimeArguments;
@class TyphoonTypeConverterRegistry;

/**
*
* @ingroup Assembly
*
* Defines a protocol for resolving built instances, injecting a pre-obtained instance using a factory containing
* definitions from one or more TyphoonAssembly classes.
*/

@protocol TyphoonComponentFactory<NSObject>

/**
* Returns an an instance of the component matching the supplied class or protocol. For example:
@code
[factory objectForType:[Knight class]];
[factory objectForType:@protocol(Quest)];
@endcode
*
* @exception NSInvalidArgumentException When no singletons or prototypes match the requested type.
* @exception NSInvalidArgumentException When when more than one singleton or prototype matches the requested type.
*
* @warning componentForType with a protocol argument is not currently supported in Objective-C++.
*
* @see: allComponentsForType:
*/
- (id)componentForType:(id)classOrProtocol;

/**
* Returns an array objects matching the given type.
*
* @see componentForType
*/
- (NSArray *)allComponentsForType:(id)classOrProtocol;

/**
* Returns the component matching the given key. For the block-style, this is the name of the method on the
* TyphoonAssembly interface, although, for block-style you'd typically use the assembly interface itself
* for component resolution.
*/
- (id)componentForKey:(NSString *)key;

- (id)componentForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args;

/**
 * You can query the factory by using object subscription syntax: _factory[@"myObject"] or even _factory[[MyObject class]]
 */
- (id)objectForKeyedSubscript:(id)key;

/**
* Injects the properties and methods of an object
*/
- (void)inject:(id)instance;

/**
* Injects the properties and methods of an object, described in definition
*/
- (void)inject:(id)instance withSelector:(SEL)selector;

- (void)makeDefault;

/**
Attach a TyphoonDefinitionPostProcessor to this component factory.
@param postProcessor The definition post processor to attach.
*/
- (void)attachDefinitionPostProcessor:(id<TyphoonDefinitionPostProcessor>)postProcessor;

/**
 Attach a TyphoonInstancePostProcessor to this component factory.
 @param postProcessor The instance post processor to attach.
 */
- (void)attachInstancePostProcessor:(id<TyphoonInstancePostProcessor>)postProcessor;

/**
 Attach a TyphoonTypeConverter to this component factory.
 @param typeConverter The type converter to attach.
 */
- (void)attachTypeConverter:(id<TyphoonTypeConverter>)typeConverter;

- (void)attachPostProcessor:(id<TyphoonDefinitionPostProcessor>)postProcessor DEPRECATED_MSG_ATTRIBUTE("use attachDefinitionPostProcessor instead");

@end

/**
*
* @ingroup Assembly
*
* This is the base class for all component factories. It defines methods for retrieving components from the factory, as well as a low-level
* API for assembling components from their constituent parts. This low-level API could be used as-is, however its intended to use a higher
* level abstraction such as TyphoonBlockComponentFactory.
*/
@interface TyphoonComponentFactory : NSObject<TyphoonComponentFactory>
{
    NSMutableArray *_registry;
    id <TyphoonComponentsPool> _singletons;
    id <TyphoonComponentsPool> _objectGraphSharedInstances;
    id <TyphoonComponentsPool> _weakSingletons;

    TyphoonCallStack *_stack;
    TyphoonTypeConverterRegistry *_typeConverterRegistry;
    NSMutableArray *_definitionPostProcessors;
    NSMutableArray *_instancePostProcessors;
    BOOL _isLoading;
}

/**
* The instantiated singletons.
*/
@property(nonatomic, strong, readonly) NSArray *singletons;

/**
* Say if the factory has been loaded.
*/
@property(nonatomic, assign, getter = isLoaded) BOOL loaded;

/**
 * The attached factory post processors.
 */
@property(nonatomic, strong, readonly) NSArray *definitionPostProcessors;

/**
 * The attached component post processors.
 */
@property(nonatomic, strong, readonly) NSArray *instancePostProcessors;



/**
* Returns the default component factory, if one has been set. @see [TyphoonComponentFactory makeDefault]. This allows resolving components
* from the Typhoon another class after the container has been set up.
*
* A more desirable approach, if possible - especially for a component that is also registered with the container is to use
* TyphoonComponentFactoryAware, which injects the component factory as a dependency on the class that needs it. This latter approach
* simplifies unit testing, in that no special approach to patching out the classes collaborators is required.
*
* @see [TyphoonComponentFactory makeDefault].
* @see TyphoonComponentFactoryAware
*
*/
+ (id)defaultFactory;


+ (void)setFactoryForResolvingUI:(TyphoonComponentFactory *)factory;

/** Factory used to resolve definition for UI. */
+ (TyphoonComponentFactory *)factoryForResolvingUI;

/** Factory used to resolve definition from TyphoonLoadedView. */
+ (TyphoonComponentFactory *)factoryForResolvingFromXibs DEPRECATED_MSG_ATTRIBUTE("use factoryForResolvingUI instead");

/**
* Mutate the component definitions and
* build the not-lazy singletons.
*/
- (void)load;

/**
* Dump all the singletons.
*/
- (void)unload;


/**
* Registers a component into the factory. Components can be declared in any order, the container will work out how to resolve them.
*/
- (void)registerDefinition:(TyphoonDefinition *)definition;


- (NSArray *)registry;

- (TyphoonTypeConverterRegistry *)typeConverterRegistry;

- (void)enumerateDefinitions:(void(^)(TyphoonDefinition *definition, NSUInteger index, TyphoonDefinition **definitionToReplace, BOOL *stop))block;


@end
