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

#import "TyphoonDefinition+ExperimentalAPI.h"

#ifdef typhoon_shorthand

#define autoWire typhoon_autoWire

#define Singleton TyphoonComponentLifecycleSingleton

#define Prototype TyphoonComponentLifecyclePrototype

static __inline__ id InjectionWithCollection(void (^collection)(TyphoonPropertyInjectedAsCollection *collectionBuilder))
{
    return TyphoonInjectionWithCollection(collection);
}

static __inline__ id InjectionWithObject(id object)
{
    return TyphoonInjectionWithObject(object);
}

static __inline__ id InjectionByType(void)
{
    return TyphoonInjectionByType();
}

static __inline__ id InjectionWithObjectFromString(NSString *string)
{
    return TyphoonInjectionWithObjectFromString(string);
}

static __inline__ id InjectionWithComponentFactory(void)
{
    return TyphoonInjectionWithComponentFactory();
}

#endif
