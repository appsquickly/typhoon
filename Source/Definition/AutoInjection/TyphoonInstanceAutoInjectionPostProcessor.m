//
// Created by Aleksey Garbarev on 29.11.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import "TyphoonInstanceAutoInjectionPostProcessor.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonDefinitionAutoInjectionPostProcessor.h"
#import "TyphoonFactoryDefinition.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"


@implementation TyphoonInstanceAutoInjectionPostProcessor

- (id)postProcessComponent:(id)component withDefinition:(TyphoonDefinition *)definition
{
    BOOL shouldCheckForAnnotation = [definition isMemberOfClass:[TyphoonFactoryDefinition class]];

    if (shouldCheckForAnnotation && [self.definitionPostProcessor hasAnnotationForClass:[component class]]) {
        TyphoonDefinition *definitionWithAnnotationProperties = [self.factory autoDefinitionForClass:[component class]];
        [self.factory doInjectionEventsOn:component withDefinition:definitionWithAnnotationProperties args:nil];
    }

    return component;
}

@end