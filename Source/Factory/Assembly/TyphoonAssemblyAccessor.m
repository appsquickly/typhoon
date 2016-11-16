////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOONFRAMEWORK.ORG
//  Copyright 2016 typhoonframework.org Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of typhoonframework.org. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonAssemblyAccessor.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonAssembly.h"
#import "TyphoonAssemblyDefinitionBuilder.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonAssemblySelectorAdviser.h"

@implementation TyphoonAssemblyAccessor

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return YES;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    @synchronized (self) {
        TyphoonComponentFactory *factory = self.factory;
        NSString *key = [TyphoonAssemblySelectorAdviser keyForSEL:anInvocation.selector];
        if ([self.collaboratingAssemblies valueForKey:key]) {
            TyphoonAssembly *assembly = self.collaboratingAssemblies[key];
            id result = assembly.accessor;
            [anInvocation retainArguments];
            [anInvocation setReturnValue:&result];
        } else if (factory) {
            [factory forwardInvocation:anInvocation];
        }
        else {
            TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsFromInvocation:anInvocation];
            TyphoonDefinition *definition = [self.definitionBuilder builtDefinitionForKey:key args:args];

            [anInvocation retainArguments];
            [anInvocation setReturnValue:&definition];
        }
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    @synchronized (self) {
        NSString *key = [TyphoonAssemblySelectorAdviser keyForSEL:aSelector];
        TyphoonComponentFactory *factory = self.factory;
        if ([self.collaboratingAssemblies valueForKey:key] || !factory) {
            return [self.assembly methodSignatureForSelector:aSelector];
        } else {
            return [factory methodSignatureForSelector:aSelector];
        }
    }
}

@end
