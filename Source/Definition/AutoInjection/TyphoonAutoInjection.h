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


#import "TyphoonInjectedObject.h"

//Injects property by definition matched by Protocol
#define InjectedProtocol(aProtocol) TyphoonInjectedObject<aProtocol>*

//Injects property by definition matched by Class
#define InjectedClass(aClass) aClass<TyphoonInjectedProtocol>*
