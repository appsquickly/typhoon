//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonDefinition+Option.h"
#import "TyphoonOptionMatcher+Internal.h"
#import "TyphoonMatcherDefinitionFactory.h"
#import "TyphoonInjections.h"

@implementation TyphoonDefinition (Option)

+ (id)withOption:(id)option yes:(id)yesDefinition no:(id)noDefinition
{
    return [self withOption:option matcher:^(TyphoonOptionMatcher *matcher) {
        [matcher caseEqual:@YES use:yesDefinition];
        [matcher caseEqual:@"YES" use:yesDefinition];
        [matcher caseEqual:@"1" use:yesDefinition];
        [matcher caseEqual:@NO use:noDefinition];
        [matcher caseEqual:@"NO" use:noDefinition];
        [matcher caseEqual:@"0" use:noDefinition];
    }];
}

+ (id)withOption:(id)option matcher:(TyphoonMatcherBlock)matcherBlock
{
    TyphoonOptionMatcher *matcher = [[TyphoonOptionMatcher alloc] initWithBlock:matcherBlock];

    TyphoonDefinition *factoryDefinition = [TyphoonDefinition withClass:[TyphoonMatcherDefinitionFactory class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(factory)];
        [definition injectProperty:@selector(matcher) with:matcher];
    }];

    return [TyphoonDefinition withClass:[TyphoonInternalFactoryContainedDefinition class] configuration:^(TyphoonDefinition *definition) {
        [definition setFactory:factoryDefinition];
        [definition setScope:TyphoonScopePrototype];
        [definition useInitializer:@selector(valueCreatedFromDefinitionMatchedOption:args:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:option];
            [initializer injectParameterWith:TyphoonInjectionWithCurrentRuntimeArguments()];
        }];
    }];
}

@end



