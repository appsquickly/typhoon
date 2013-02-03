////////////////////////////////////////////////////////////////////////////////
//
//  MOD PRODUCTIONS
//  Copyright 2013 Mod Productions
//  All Rights Reserved.
//
//  NOTICE: Mod Productions permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonSharedComponentFactoryTests.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonBundleResource.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "TyphoonXmlComponentFactory.h"

@interface TyphoonXmlComponentFactoryTests : TyphoonSharedComponentFactoryTests
@end

@implementation TyphoonXmlComponentFactoryTests

- (void)setUp
{
    _componentFactory = [[TyphoonXmlComponentFactory alloc] initWithConfigFileName:@"MiddleAgesAssembly.xml"];
    TyphoonPropertyPlaceholderConfigurer* configurer = [[TyphoonPropertyPlaceholderConfigurer alloc] init];
    [configurer usePropertyStyleResource:[TyphoonBundleResource withName:@"SomeProperties.properties"]];
    [_componentFactory attachMutator:configurer];
}

@end