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

#import "TyphoonInjections.h"

#ifdef typhoon_shorthand

#define autoWire typhoon_autoWire

#define Singleton TyphoonComponentLifecycleSingleton

#define Prototype TyphoonComponentLifecyclePrototype

//static __inline__ id InjectionWithCollection(void (^collection)(id<TyphoonInjectedAsCollection> collectionBuilder))
//{
//    return TyphoonInjectionWithCollection(collection);
//}
//
//static __inline__ id InjectionWithCollectionAndType(Class collectionClass, void (^collection)(id<TyphoonInjectedAsCollection> collectionBuilder))
//{
//    return TyphoonInjectionWithCollectionAndType(collectionClass, collection);
//}
//
//static __inline__ id InjectionWithObjectFromString(NSString *string)
//{
//    return TyphoonInjectionWithObjectFromString(string);
//}
//
//static __inline__ id InjectionWithObjectFromStringWithType(NSString *string, Class objectClass)
//{
//    return TyphoonInjectionWithObjectFromStringWithType(string, objectClass);
//}
//
//static __inline__ id InjectionWithRuntimeArgumentAtIndex(NSUInteger argumentIndex)
//{
//    return TyphoonInjectionWithRuntimeArgumentAtIndex(argumentIndex);
//}

#endif
