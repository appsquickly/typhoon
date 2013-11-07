//
// Created by Robert Gilliam on 11/5/13.
//


#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"


@interface DefinitionInheritanceAssembly : TyphoonAssembly

- (id)knightWithNoDependenciesButInitializer;

- (id)childKnightWithNoDependenciesButInitializer;

- (id)childKnightWithNoDependencies;

- (id)childKnightWithConstructorDependency;

- (id)childKnightWithOverridenConstructorDependency;

- (id)childWidgetWithDependencyOnCInheritingFromAandB;
@end