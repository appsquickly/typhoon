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
#import "TyphoonInjectionByComponentFactory.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"

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

//-------------------------------------------------------------------------------------------
#pragma mark - <TyphoonObjectWithCustomInjection>
//-------------------------------------------------------------------------------------------

- (id<TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection
{
    return [[TyphoonInjectionByComponentFactory alloc] init];
}

//-------------------------------------------------------------------------------------------
#pragma mark - <TyphoonComponentFactory>
//-------------------------------------------------------------------------------------------

- (id)componentForType:(id)classOrProtocol {
    return [self.factory componentForType:classOrProtocol];
}

- (NSArray *)allComponentsForType:(id)classOrProtocol {
  
    return [self.factory allComponentsForType:classOrProtocol];
}

- (id)componentForKey:(NSString *)key {
  
    return [self.factory componentForKey:key];
}

- (id)componentForKey:(NSString *)key args:(TyphoonRuntimeArguments *)args {
  
    return [self.factory componentForKey:key args:args];
}

- (void)inject:(id)instance {
  
    [self.factory inject:instance];
}

- (void)inject:(id)instance withSelector:(SEL)selector {

    [self.factory inject:instance withSelector:selector];
}


- (void)makeDefault {

    [self.factory makeDefault];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-implementations"
- (void)attachPostProcessor:(id <TyphoonDefinitionPostProcessor>)postProcessor {
    [self attachDefinitionPostProcessor:postProcessor];
}
#pragma clang diagnostic pop

- (void)attachDefinitionPostProcessor:(id <TyphoonDefinitionPostProcessor>)postProcessor {

    [self.factory attachDefinitionPostProcessor:postProcessor];
}

- (void)attachInstancePostProcessor:(id<TyphoonInstancePostProcessor>)postProcessor {

    [self.factory attachInstancePostProcessor:postProcessor];
}

- (void)attachTypeConverter:(id<TyphoonTypeConverter>)typeConverter {

    [self.factory attachTypeConverter:typeConverter];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self.factory objectForKeyedSubscript:key];
}

@end
