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

#import <SenTestingKit/SenTestingKit.h>

@class TyphoonComponentFactory;

/**
* These tests are executed by both XmlComponentFactory and BlockComponentFactory.
*/
@interface TyphoonSharedComponentFactoryTests : SenTestCase {
    TyphoonComponentFactory *_componentFactory;
    TyphoonComponentFactory *_exceptionTestFactory;
    TyphoonComponentFactory *_circularDependenciesFactory;
    TyphoonComponentFactory *_singletonsChainFactory;
    TyphoonComponentFactory *_infrastructureComponentsFactory;
}

@end