//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "TyphoonMatcherDefinitionFactory.h"
#import "TyphoonOptionMatcher+Internal.h"
#import "TyphoonDefinition+Infrastructure.h"


@implementation TyphoonMatcherDefinitionFactory

- (id)valueCreatedFromDefinitionMatchedOption:(id)optionValue args:(TyphoonRuntimeArguments *)args
{
    __block id result = nil;
    [self.matcher findDefinitionMatchedValue:optionValue withFactory:self.factory usingBlock:^(TyphoonDefinition *definition, TyphoonRuntimeArguments *referenceArguments) {
        TyphoonRuntimeArguments *definitionArgs = [TyphoonRuntimeArguments argumentsFromRuntimeArguments:args appliedToReferenceArguments:referenceArguments];
        result = [self.factory objectForDefinition:definition args:definitionArgs];
    }];
    NSParameterAssert(result);
    return result;
}

@end

@implementation TyphoonInternalFactoryContainedDefinition
@end