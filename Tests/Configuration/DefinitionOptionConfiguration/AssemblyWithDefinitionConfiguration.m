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


#import "AssemblyWithDefinitionConfiguration.h"

#define TRUE_OPTION_AS_MACROS 1

@implementation AssemblyWithDefinitionConfiguration

- (id)trueString
{
    return [TyphoonDefinition withClass:[NSString class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@"TRUE"];
        }];
    }];
}

- (id)falseString
{
    return [TyphoonDefinition withClass:[NSString class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@"FALSE"];
        }];
    }];
}

- (id)zeroString
{
    return [TyphoonDefinition withClass:[NSString class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@"ZERO"];
        }];
    }];
}

- (id)falseOptionDefinition
{
    return [TyphoonDefinition withClass:[NSNumber class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(numberWithBool:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:@NO];
        }];
    }];
}

- (id)definitionMatchedTrueValue
{
    return [TyphoonDefinition withOption:@(TRUE_OPTION_AS_MACROS) yes:[self trueString] no:[self falseString]];
}

- (id)definitionMatchedRuntimeValue:(NSNumber *)value
{
    return [TyphoonDefinition withOption:value yes:[self trueString] no:[self falseString]];
}

- (id)definitionMatchedFalseAsString
{
    return [TyphoonDefinition withOption:@"NO" yes:[self trueString] no:[self falseString]];
}

- (id)definitionMatchedOneAsString
{
    return [TyphoonDefinition withOption:@"1" yes:[self trueString] no:[self falseString]];
}

- (id)definitionMatchedOneAsNumber
{
    return [TyphoonDefinition withOption:@1 yes:[self trueString] no:[self falseString]];
}

- (id)definitionMatchedByAnotherDefinitionWithFalse
{
    return [TyphoonDefinition withOption:[self falseOptionDefinition] yes:[self trueString] no:[self falseString]];
}

- (id)definitionMatchedDefinitionName:(NSString *)definitionName
{
    return [TyphoonDefinition withOption:definitionName matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher useDefinitionWithKeyMatchedOptionValue];
    }];
}

- (id)definitionMatchedByCustomMatcherFromOption:(NSString *)option
{
    return [TyphoonDefinition withOption:option matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseEqual:@"positive" use:[self trueString]];
        [matcher caseEqual:@"negative" use:[self falseString]];
        [matcher caseEqual:@"nothing" use:[self zeroString]];
    }];
}

- (id)definitionMatchedByCustomMatcherOrNameFromOption:(NSString *)option
{
    return [TyphoonDefinition withOption:option matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseEqual:@"positive" use:[self trueString]];
        [matcher caseEqual:@"negative" use:[self falseString]];
        [matcher caseEqual:@"nothing" use:[self zeroString]];
        [matcher useDefinitionWithKeyMatchedOptionValue];
    }];
}
- (id)definitionMatchedByCustomMatcherWithDefaultFromOption:(NSString *)option
{
    return [TyphoonDefinition withOption:option matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseEqual:@"positive" use:[self trueString]];
        [matcher caseEqual:@"negative" use:[self falseString]];
        [matcher caseEqual:@"nothing" use:[self zeroString]];
        [matcher defaultUse:[self zeroString]];
    }];
}

- (id)definitionMatchedByCustomMatcherFromOption:(NSString *)option withString:(NSString *)string
{
    return [TyphoonDefinition withOption:option matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseEqual:@"positive" use:[self trueString]];
        [matcher caseEqual:@"negative" use:[self falseString]];
        [matcher caseEqual:@"nothing" use:[self zeroString]];
        [matcher caseEqual:@"custom" use:[self stringWithText:string]];
        [matcher defaultUse:[self zeroString]];
    }];
}

- (id)stringWithText:(NSString *)text
{
    return [TyphoonDefinition withClass:[NSString class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithString:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:text];
        }];
    }];
}

- (id)definitionMatchedByCustomInjectionsMatcherFromOption:(NSString *)option withString:(NSString *)string
{
    return [TyphoonDefinition withOption:option matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseEqual:@"positive" use:[self trueString]];
        [matcher caseEqual:@"negative" use:[self falseString]];
        [matcher caseEqual:@"optionItSelf" use:option];
        [matcher caseEqual:@"customString" use:[self stringWithText:string]];
        [matcher caseEqual:@"defaultString" use:@"Typhoon"];
        [matcher caseEqual:nil use:[NSNull null]];
        [matcher caseMemberOfClass:[NSNull class] use:nil];
        [matcher defaultUse:[self zeroString]];
    }];
}

- (id)definitionWithCircularDescription
{
    return [TyphoonDefinition withClass:[NSMutableArray class] configuration:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(addObject:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self definitionThatDependsOnAnother]];
        }];
        [definition injectMethod:@selector(addObject:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self definitionWithCircularDependency]];
        }];
        definition.scope = TyphoonScopePrototype;
    }];
}

- (id)definitionWithCircularDependency
{
    return [TyphoonDefinition withOption:@"value" matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseEqual:@"value" use:[self definitionThatDependsOnAnother]];
    }];
}

- (id)definitionThatDependsOnAnother
{
    return [TyphoonDefinition withClass:[NSValue class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(valueWithPointer:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:[self definitionWithCircularDescription]];
        }];
    }];
}

- (id)definitionWithIncorrectCircularDependency
{
    return [TyphoonDefinition withOption:@"value" matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseEqual:@"value" use:[self definitionWithIncorrectCircularDependency]];
    }];
}

@end
