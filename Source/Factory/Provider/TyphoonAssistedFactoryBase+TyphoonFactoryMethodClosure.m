////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonAssistedFactoryBase+TyphoonFactoryMethodClosure.h"

#include <objc/runtime.h>

#import "TyphoonAssistedFactoryMethodClosure.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"

static const void *sFactoryMethodClosures = &sFactoryMethodClosures;

@implementation TyphoonAssistedFactoryBase (TyphoonFactoryMethodClosure)

+ (void)_fmc_setClosure:(id <TyphoonAssistedFactoryMethodClosure>)closure forSelector:(SEL)selector
{
    NSMutableDictionary *closures = [self _fmc_closures];
    @synchronized (closures) {
        closures[NSStringFromSelector(selector)] = closure;
    }
}

+ (id <TyphoonAssistedFactoryMethodClosure>)_fmc_closureForSelector:(SEL)selector
{
    NSMutableDictionary *closures = [self _fmc_closures];
    @synchronized (closures) {
        return closures[NSStringFromSelector(selector)];
    }
}

+ (NSMutableDictionary *)_fmc_closures
{
    NSMutableDictionary *closures = objc_getAssociatedObject(self, sFactoryMethodClosures);
    if (!closures) {
        @synchronized (self) {
            closures = objc_getAssociatedObject(self, sFactoryMethodClosures);
            // yes, I know, double-checked locking
            if (!closures) {
                closures = [NSMutableDictionary dictionary];
                objc_setAssociatedObject(self, sFactoryMethodClosures, closures, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }

    return closures;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    // Return the method signature of the real object, or find the method
    // signature from the corresponding factory method closure.
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        id <TyphoonAssistedFactoryMethodClosure> closure = [[self class] _fmc_closureForSelector:aSelector];
        signature = closure.methodSignature;
    }

    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    // Find the factory method closure related to this invocation selector, and
    // create a new invocation from it, using the arguments of this invocation.
    id <TyphoonAssistedFactoryMethodClosure> closure = [[self class] _fmc_closureForSelector:anInvocation.selector];
    NSInvocation *closureInvocation = [closure invocationWithFactory:self forwardedInvocation:anInvocation];
    [closureInvocation invoke];

    // Finally, copy the return value from one invocation to another.
    NSUInteger methodReturnLength = [closure.methodSignature methodReturnLength];
    void *returnValue = malloc(methodReturnLength);
    [closureInvocation getReturnValue:returnValue];

    [self.componentFactory injectAssemblyOnInstanceIfTyphoonAware:*(__unsafe_unretained id *) returnValue];

    [anInvocation setReturnValue:returnValue];
    free(returnValue);
}

@end
