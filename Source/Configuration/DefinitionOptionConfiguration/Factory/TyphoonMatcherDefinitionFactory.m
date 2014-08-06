//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"
#import "TyphoonMatcherDefinitionFactory.h"
#import "TyphoonOptionMatcher+Internal.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonInjection.h"


@implementation TyphoonMatcherDefinitionFactory

- (id)valueCreatedFromDefinitionMatchedOption:(id)optionValue args:(TyphoonRuntimeArguments *)args
{
    id<TyphoonInjection>injection = [self.matcher injectionMatchedValue:optionValue];

    TyphoonInjectionContext *context = [TyphoonInjectionContext new];
    context.args = args;
    context.factory = self.factory;
    context.raiseExceptionIfCircular = YES;
    context.destinationType = [TyphoonTypeDescriptor descriptorWithEncodedType:@encode(id)];

    __block id result = nil;
    [injection valueToInjectWithContext:context completion:^(id value) {
        result = value;
    }];

    return result;
}

@end

@implementation TyphoonInternalFactoryContainedDefinition
@end