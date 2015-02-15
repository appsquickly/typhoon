////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

@interface NSObject (FactoryHooks)

/**
 * @ingroup Assembly
 *
 * Implementation of method typhoonSetFactory indicates that a component wishes to be aware of the TyphoonComponentFactory in order to resolve another component.
 * Typically we'd want to inject all the dependencies, however there are some cases where its desirable to load a component from the factory
 * at runtime. One example is view controller transitions where a given view controller has:
 *
 * - All of the dependencies for its main use-case injected
 * - Looks up the view controller for a transition from the container. This allows using prototype scope to load one object-graph at a time,
 * thus making efficient use of memory.
 *
 */

/**
 * Accepts the TyphoonComponentFactory via setter-injection, allowing the factory to be stored to a property or ivar. Note that this method
 * contract uses the type id, which if you're using a block-style assembly allows setting the factory to the TyphoonAssembly sub-class
 * itself without casting. The underlying type is TyphoonComponentFactory.
 *
 * ##Examples:
 
 @code
 //Using the TyphoonComponentFactory interface:
 - (void)typhoonSetFactory:(TyphoonComponentFactory*)factory
 {
 
 _factory = factory;
 MyAnalyticsService* service = [factory componentForType:[MyAnalyticsService class];
 }
 @endcode
 
 @code
 //Using an Assembly interface
 - (void)typhoonSetFactory:(MyAssemblyType*)assembly
 {
 _assembly = assembly;
 MyAnalyticsService* service = [assembly analyticsService];
 }
 @endcode
 
 * @note Whether the factory is injected as a TyphoonComponentFactory or a TyphoonAssembly sub-class, it can still be casted from one to the
 * other.
 */
- (void)typhoonSetFactory:(id)theFactory;


/**
 * @ingroup Assembly
 *
 * Typhoon components can implement this methods to participate in property-injection life-cycle events. This gives some of the benefits
 * of initializer-injection - the ability to provide before / after validation - while still allowing the flexibility of property injection.
 *
 * @note If you don't wish to implement these methods on your class, you can also define custom callback selectors on TyphoonDefinition.
 *
 * @see TyphoonDefinition.beforeInjections
 * @see TyphoonDefinition.afterInjections
 *
 */

/**
 * Typhoon calls this method (if implemented) just before property and method injections
 */
- (void)typhoonWillInject;

/**
 * Typhoon calls this method (if implemented) just after property and method injections
 */
- (void)typhoonDidInject;

@end
