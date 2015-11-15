//
//  TyphoonNamespacingTests.m
//  Typhoon
//
//  Created by Egor Tolstoy on 15/11/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MiddleAgesAssembly.h"
#import "CollaboratingMiddleAgesAssembly.h"
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"

@interface TyphoonNamespacingTests : XCTestCase

@end

@implementation TyphoonNamespacingTests

- (void)test_assembly_definition_namespacing
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly new];
    TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:assembly];
    
    TyphoonDefinition *definition = [factory definitionForKey:NSStringFromSelector(@selector(knight))];
    XCTAssertEqualObjects(definition.space.key, NSStringFromClass([MiddleAgesAssembly class]));
}

- (void)test_collaborating_assemblies_definition_namespacing
{
    MiddleAgesAssembly *assembly = [MiddleAgesAssembly new];
    CollaboratingMiddleAgesAssembly *collaboratingAssembly = [CollaboratingMiddleAgesAssembly assembly];
    TyphoonBlockComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[assembly, collaboratingAssembly]];
    
    TyphoonDefinition *definition1 = [factory definitionForKey:NSStringFromSelector(@selector(knight))];
    XCTAssertEqualObjects(definition1.space.key, NSStringFromClass([MiddleAgesAssembly class]));
    
    TyphoonDefinition *definition2 = [factory definitionForKey:NSStringFromSelector(@selector(knightWithExternalQuest))];
    XCTAssertEqualObjects(definition2.space.key, NSStringFromClass([CollaboratingMiddleAgesAssembly class]));
}

@end
