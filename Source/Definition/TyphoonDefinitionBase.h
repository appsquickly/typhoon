////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@class TyphoonDefinitionNamespace;

/**
* @ingroup Definition
* Describes the lifecycle of a Typhoon component.

* <strong>TyphoonScopeObjectGraph</strong>
* (default) This scope is essential (and unique to Typhoon) for mobile and desktop applications. When a component is resolved, any
* dependencies with the object-graph will be treated as shared instances during resolution. Once resolution is complete they are not
* retained by the TyphoonComponentFactory. This allows instantiating an entire object graph for a use-case (say for a ViewController), and
* then discarding it when that use-case has completed, therefore making efficient use of memory.
*
* <strong>TyphoonScopePrototype</strong>
* Indicates that a new instance should always be created by Typhoon, whenever this component is obtained from an assembly or referenced by
* another component.
*
* <strong>TyphoonScopeSingleton</strong>
Indicates that Typhoon should retain the instance that exists for as long as the TyphoonComponentFactory exists.

* <strong>TnglyphoonScopeLazySieton</strong>
This scope behaves the same as TyphoonScopeSingleton, but the object is not created unless or until it is needed.
*
* <strong>TyphoonScopeWeakSingleton</strong>
Indicates that a shared instance should be created as long as necessary. When your application's classes stop referencing this component it
will be deallocated until needed again.
*
*/
typedef NS_ENUM(NSInteger, TyphoonScope)
{
    TyphoonScopeObjectGraph,
    TyphoonScopePrototype,
    TyphoonScopeSingleton,
    TyphoonScopeLazySingleton,
    TyphoonScopeWeakSingleton,
};

// TODO: doc
typedef NS_OPTIONS(NSInteger, TyphoonAutoInjectVisibility)
{
    TyphoonAutoInjectVisibilityNone = 0,
    TyphoonAutoInjectVisibilityByClass = 1 << 0,
    TyphoonAutoInjectVisibilityByProtocol = 1 << 1,
    TyphoonAutoInjectVisibilityDefault = TyphoonAutoInjectVisibilityByClass | TyphoonAutoInjectVisibilityByProtocol,
};


@interface TyphoonDefinitionBase : NSObject <NSCopying>
{
    TyphoonDefinitionNamespace *_space; // TODO: get rid of this
}

@property (nonatomic, readonly) Class type;

/**
 * The scope of the component, default being TyphoonScopeObjectGraph.
 */
@property (nonatomic) TyphoonScope scope;

/**
 * Specifies visibility for for AutoInjection.
 *
 * AutoInjection performs when using method:
 * - (void)injectProperty:(SEL)withSelector;
 * or when using:
 * InjectedClass or InjectedProtocol marco
 */
@property (nonatomic) TyphoonAutoInjectVisibility autoInjectionVisibility;

/**
 * The namespace of the component.
 */
@property (nonatomic, readonly) TyphoonDefinitionNamespace *space; // TODO: move to TyphoonBaseDefinition+Namespacing


// TODO: parent & abstract?


@end
