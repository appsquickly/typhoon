////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonDefinition+Namespacing.h"

@interface TyphoonDefinition ()

@property (nonatomic, strong) TyphoonDefinitionNamespace *space;

@end

@implementation TyphoonDefinition (Namespacing)

- (void)applyGlobalNamespace {
    TyphoonDefinitionNamespace *namespace = [TyphoonDefinitionNamespace globalNamespace];
    _space = namespace;
}

- (void)applyConcreteNamespace:(NSString *)key {
    TyphoonDefinitionNamespace *namespace = [TyphoonDefinitionNamespace namespaceWithKey:key];
    _space = namespace;
}

@end
