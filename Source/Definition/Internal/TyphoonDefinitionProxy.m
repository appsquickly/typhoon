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


#import "TyphoonDefinitionProxy.h"
#import "TyphoonRuntimeArguments.h"

@implementation TyphoonDefinitionProxy
{
    Class _definitionClass;
    NSMutableArray *_methodConfigurationBlocks;
}

- (instancetype)initWithClass:(Class)clazz
{
    _definitionClass = clazz;
    _methodConfigurationBlocks = [NSMutableArray array];
    
    return self;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    return [TyphoonDefinitionProxy class] == aClass;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_definitionClass instanceMethodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    BOOL isInitializer = _methodConfigurationBlocks.count == 0;

    if (isInitializer) {
        __unsafe_unretained id unsafeSelf = self;
        [anInvocation setReturnValue:&unsafeSelf];
    }
    
    TyphoonRuntimeArguments *arguments = [TyphoonRuntimeArguments argumentsFromInvocation:anInvocation];
    
    void (^parametersBlock)(TyphoonMethod *) = ^(TyphoonMethod *method) {
        [arguments enumerateArgumentsUsingBlock:^(id argument, NSUInteger index, BOOL *stop) {
            [method injectParameterWith:argument];
        }];
    };
    
    TyphoonDefinitionBlock configurationBlock = ^(TyphoonDefinition *definition) {
        if (isInitializer) {
            [definition useInitializer:anInvocation.selector parameters:parametersBlock];
        } else {
            [definition injectMethod:anInvocation.selector parameters:parametersBlock];
        }
    };
    
    [_methodConfigurationBlocks addObject:[configurationBlock copy]];
}

- (TyphoonDefinition *)__buildTyphoonDefinition
{
    return [TyphoonDefinition withClass:_definitionClass configuration:^(TyphoonDefinition *definition) {
        for (TyphoonDefinitionBlock block in self->_methodConfigurationBlocks) {
            block(definition);
        }
    }];
}

@end
