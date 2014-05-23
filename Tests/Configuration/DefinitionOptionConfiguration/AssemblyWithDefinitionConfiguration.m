//
//  AssemblyWithDefinitionConfiguration.m
//  Typhoon
//
//  Created by Aleksey Garbarev on 22.05.14.
//
//

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
        [matcher caseOption:@"positive" use:[self trueString]];
        [matcher caseOption:@"negative" use:[self falseString]];
        [matcher caseOption:@"nothing" use:[self zeroString]];
    }];
}

- (id)definitionMatchedByCustomMatcherOrNameFromOption:(NSString *)option
{
    return [TyphoonDefinition withOption:option matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseOption:@"positive" use:[self trueString]];
        [matcher caseOption:@"negative" use:[self falseString]];
        [matcher caseOption:@"nothing" use:[self zeroString]];
        [matcher useDefinitionWithKeyMatchedOptionValue];
    }];
}
- (id)definitionMatchedByCustomMatcherWithDefaultFromOption:(NSString *)option
{
    return [TyphoonDefinition withOption:option matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseOption:@"positive" use:[self trueString]];
        [matcher caseOption:@"negative" use:[self falseString]];
        [matcher caseOption:@"nothing" use:[self zeroString]];
        [matcher defaultUse:[self zeroString]];
    }];
}


@end
