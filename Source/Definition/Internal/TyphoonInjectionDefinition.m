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

#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonInjectionDefinition.h"


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

- (void)enumerateInjectionsOfKind:(Class)injectionClass options:(TyphoonInjectionsEnumerationOption)options usingBlock:(TyphoonInjectionsEnumerationBlock)block
{
    if ([_injection isKindOfClass:injectionClass]) {
        id injectionToReplace = nil;
        BOOL stop = NO;
        
        block(_injection, &injectionToReplace, &stop);
        
        if (injectionToReplace) {
            _injection = injectionToReplace;
        }
    }
}

@end
