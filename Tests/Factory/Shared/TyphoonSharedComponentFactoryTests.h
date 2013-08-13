////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>

@class TyphoonComponentFactory;

/**
* These tests are executed by both XmlComponentFactory and BlockComponentFactory.
*/
@interface TyphoonSharedComponentFactoryTests : SenTestCase
{
    TyphoonComponentFactory* _componentFactory;
    TyphoonComponentFactory* _exceptionTestFactory;
    TyphoonComponentFactory* _circularDependenciesFactory;
    TyphoonComponentFactory* _singletonsChainFactory;
}

@end