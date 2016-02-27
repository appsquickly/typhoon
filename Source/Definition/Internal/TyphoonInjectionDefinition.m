////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOONFRAMEWORK.ORG
//  Copyright 2015 typhoonframework.org Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of typhoonframework.org. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonInjectionDefinition.h"
#import "TyphoonDefinition+Infrastructure.h"


@implementation TyphoonInjectionDefinition
{
    id<TyphoonInjection> _injection;
}

- (instancetype)initWithInjection:(id<TyphoonInjection>)injection
{
    self = [super initWithClass:[NSObject class] key:nil];
    if (self) {
        _injection = injection;
    }
    return self;
}

#pragma mark - Overriden methods

- (TyphoonMethod *)initializer
{
    return nil;
}

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    TyphoonInjectionContext *context = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args raiseExceptionIfCircular:YES];
    context.destinationType = [TyphoonTypeDescriptor descriptorWithEncodedType:@encode(id)];

    __block id valueToInject = nil;

    [_injection valueToInjectWithContext:context completion:^(id value) {
        valueToInject = value;
    }];

    return valueToInject;
}

- (BOOL)isCandidateForInjectedClass:(Class)clazz includeSubclasses:(BOOL)includeSubclasses
{
    return NO;
}

- (BOOL)isCandidateForInjectedProtocol:(Protocol *)aProtocol
{
    return NO;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionDefinition *copy = [super copyWithZone:zone];
    copy->_injection = [_injection copyWithZone:zone];
    return copy;
}

@end
