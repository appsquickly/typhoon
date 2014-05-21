//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "TyphoonMatcherDefinitionFactory.h"
#import "TyphoonOptionMatcher+Internal.h"


@implementation TyphoonMatcherDefinitionFactory

- (id)valueCreatedFromDefinitionMatchedOption:(id)optionValue
{
    TyphoonDefinition *definition = [self.matcher definitionMatchingValue:optionValue withComponentFactory:self.factory];
    return [self.factory objectForDefinition:definition args:nil];
}

@end

@implementation TyphoonInternalFactoryContainedDefinition
@end