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

#import "TyphoonAssembly.h"


@interface AssemblyWithDefinitionConfiguration : TyphoonAssembly

- (id)definitionMatchedTrueValue;

- (id)definitionMatchedRuntimeValue:(NSNumber *)value;

- (id)definitionMatchedFalseAsString;

- (id)definitionMatchedOneAsString;

- (id)definitionMatchedOneAsNumber;

- (id)definitionMatchedByAnotherDefinitionWithFalse;

- (id)definitionMatchedDefinitionName:(NSString *)definitionName;

- (id)definitionMatchedByCustomMatcherFromOption:(NSString *)option;

- (id)definitionMatchedByCustomMatcherOrNameFromOption:(NSString *)option;

- (id)definitionMatchedByCustomMatcherWithDefaultFromOption:(NSString *)option;

- (id)definitionMatchedByCustomMatcherFromOption:(NSString *)option withString:(NSString *)string;

- (id)definitionMatchedByCustomInjectionsMatcherFromOption:(NSString *)option withString:(NSString *)string;

- (id)definitionWithCircularDescription;

- (id)definitionWithIncorrectCircularDependency;
@end
