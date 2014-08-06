//
//  AssemblyWithDefinitionConfiguration.h
//  Typhoon
//
//  Created by Aleksey Garbarev on 22.05.14.
//
//

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
