////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "TyphoonComponentFactoryPostProcessor.h"
#import "TyphoonComponentsPool.h"

@class TyphoonDefinition;
@class TyphoonCallStack;
@class TyphoonRuntimeArguments;

/**
*
* @ingroup Factory
*
* This is the base class for all component factories. It defines methods for retrieving components from the factory, as well as a low-level
* API for assembling components from their constituent parts. This low-level API could be used as-is, however its intended to use a higher
* level abstraction such as TyphoonBlockComponentFactory.
*/
@interface TyphoonComponentFactory : NSObject
{
    NSMutableArray *_registry;
    id <TyphoonComponentsPool> _singletons;
    id <TyphoonComponentsPool> _objectGraphSharedInstances;
    id <TyphoonComponentsPool> _weakSingletons;

    TyphoonCallStack *_stack;
    NSMutableArray *_factoryPostProcessors;
    NSMutableArray *_componentPostProcessors;
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
@property(nonatomic, strong, readonly) NSArray *factoryPostProcessors;

/**
 * The attached component post processors.
 */
@property(nonatomic, strong, readonly) NSArray *componentPostProcessors;



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
* Returns the default component factory, if one has been set. @see [TyphoonComponentFactory makeDefault]. This allows resolving components
* from the Typhoon another class after the container has been set up.
*
* This method is only integrating Typhoon into legacy environments - classes not managed by Typhoon, and its use elsewhere is discouraged
* as it will create a hard-wired dependency on Typhoon, whenever the default factory is retrieved.
*
* A more desirable approach is to use TyphoonComponentFactoryAware or to inject the factory via an assembly. This simplifies unit testing.
*
* ## Alternative approach: inject the factory (in this case posing behind a TyphoonAssembly subclass):

@code

- (id)loyaltyManagementController
{
    return [TyphoonDefinition withClass:[LoyaltyManagementViewController class]
        properties:^(TyphoonDefinition* definition)
    {
        definition.scope = TyphoonScopePrototype;
        //Inject the TyphoonComponentFactory posing as an assembly
        [definition injectProperty:@selector(assembly)];
    }];
}

@endcode

* @see [TyphoonComponentFactory makeDefault].
* @see TyphoonComponentFactoryAware
*
*/
- (void)makeDefault;

/**
* Registers a component into the factory. Components can be declared in any order, the container will work out how to resolve them.
*/
- (void)registerDefinition:(TyphoonDefinition *)definition;

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

- (NSArray *)registry;

/**
 Attach a TyphoonComponentFactoryPostProcessor to this component factory.
 @param postProcessor The post-processor to attach.
 */
- (void)attachPostProcessor:(id <TyphoonComponentFactoryPostProcessor>)postProcessor;

/**
 * Injects the properties and methods of an object
 */
- (void)inject:(id)instance;

/**
 * Injects the properties and methods of an object, described in definition
 */
- (void)inject:(id)instance withDefinition:(SEL)selector;

@end
