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

@class TyphoonComponentFactory;

/**
* @ingroup Factory
*
* This protocol indicates that a component wishes to be aware of the TyphoonComponentFactory in order to resolve another component.
* Typically we'd want to inject all the dependencies, however there are some cases where its desirable to load a component from the factory
* at runtime. One example is view controller transitions where a given view controller has:
*
* - All of the dependencies for its main use-case injected
* - Looks up the view controller for a transition from the container. This allows using prototype scope to load one object-graph at a time,
* thus making efficient use of memory.
*
*/
@protocol TyphoonComponentFactoryAware <NSObject>

/**
* Accepts the TyphoonComponentFactory via setter-injection, allowing the factory to be stored to a property or ivar. Note that this method
* contract uses the type id, which if you're using a block-style assembly allows setting the factory to the TyphoonAssembly sub-class
* itself without casting. The underlying type is TyphoonComponentFactory.
*
* ##Examples:

@code
//Using the TyphoonComponentFactory interface:
- (void)setFactory:(TyphoonComponentFactory*)factory
{

    _factory = factory;
    MyAnalyticsService* service = [factory componentForType:[MyAnalyticsService class];
}
@endcode

@code
//Using an Assembly interface
- (void)setFactory:(MyAssemblyType*)assembly
{
    _assembly = assembly;
    MyAnalyticsService* service = [assembly analyticsService];
}
@endcode

* @note Whether the factory is injected as a TyphoonComponentFactory or a TyphoonAssembly sub-class, it can still be casted from one to the
* other.
*/
- (void)setFactory:(id)theFactory;

@end
