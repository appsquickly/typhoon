//
//  TyphoonInjectionDictionary.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 14.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByDictionary.h"
#import "TyphoonInjections.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonIntrospectiveNSObject.h"
#import "TyphoonTypeDescriptor.h"

@interface TyphoonInjectionByDictionary ()

@property(nonatomic, strong) NSMutableDictionary *injections;
@property(nonatomic) Class requiredClass;

@end

@implementation TyphoonInjectionByDictionary

+ (BOOL)isDictionaryClass:(Class)dictionaryClass
{
    dictionaryClass = [self dictionaryMutableClassFromClass:dictionaryClass];
    BOOL success = YES;
    success &= [dictionaryClass instancesRespondToSelector:@selector(initWithCapacity:)];
    success &= [dictionaryClass instancesRespondToSelector:@selector(count)];
    success &= [dictionaryClass instancesRespondToSelector:@selector(setObject:forKey:)];
    success &= [dictionaryClass instancesRespondToSelector:@selector(enumerateKeysAndObjectsUsingBlock:)];

    return success;
}

+ (Class)dictionaryMutableClassFromClass:(Class)dictionaryClass
{
    Class result;

    if ([dictionaryClass isSubclassOfClass:[NSDictionary class]]) {
        result = [NSMutableDictionary class];
    }
    else {
        result = dictionaryClass;
    }

    return result;
}

- (instancetype)initWithDictionary:(id)dictionary requiredClass:(Class)dictionaryClass
{
    self.requiredClass = dictionaryClass;

    if (self.requiredClass && ![TyphoonInjectionByDictionary isDictionaryClass:self.requiredClass]) {
        [NSException raise:NSInvalidArgumentException format:@"Required dictionary type '%@' is not dictionary.",
                                                             NSStringFromClass(self.requiredClass)];
    }

    return [self initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(id <TyphoonDictionary>)dictionary
{
    self = [super init];
    if (self) {
        self.injections = [[NSMutableDictionary alloc] initWithCapacity:[dictionary count]];

        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id injection = TyphoonMakeInjectionFromObjectIfNeeded(obj);
            [self.injections setObject:injection forKey:key];
        }];
    }
    return self;
}

- (id <TyphoonDictionary>)dictionaryWithClass:(Class)dictionaryClass withResolvedInjectionsWithFactory:(TyphoonComponentFactory *)factory
    args:(TyphoonRuntimeArguments *)args
{
    Class mutableClass = [TyphoonInjectionByDictionary dictionaryMutableClassFromClass:dictionaryClass];
    id <TyphoonDictionary> result = [[[mutableClass class] alloc] initWithCapacity:[self.injections count]];

    [self.injections enumerateKeysAndObjectsUsingBlock:^(id key, id <TyphoonPropertyInjection> injection, BOOL *stop) {
        id value = [injection valueToInjectPropertyOnInstance:nil withFactory:factory args:args];
        [result setObject:value forKey:key];
    }];
    return result;
}

- (NSUInteger)count
{
    return [self.injections count];
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByDictionary *copied = [[TyphoonInjectionByDictionary alloc] init];
    copied.injections = self.injections;
    copied.requiredClass = self.requiredClass;
    [self copyBaseProperiesTo:copied];
    return copied;
}

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    Class dictionaryClass = self.requiredClass;
    if (!dictionaryClass) {
        TyphoonTypeDescriptor *type = [instance typeForPropertyWithName:self.propertyName];
        dictionaryClass = type.classOrProtocol;
    }

    if (![TyphoonInjectionByDictionary isDictionaryClass:dictionaryClass]) {
        [NSException raise:NSInvalidArgumentException format:@"Property named '%@' on '%@' is not dictionary.", self.propertyName,
                                                             NSStringFromClass(dictionaryClass)];
    }

    return [self dictionaryWithClass:dictionaryClass withResolvedInjectionsWithFactory:factory args:args];
}

- (void)setArgumentOnInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory
    args:(TyphoonRuntimeArguments *)args
{
    if (!self.requiredClass) {
        [NSException raise:NSInvalidArgumentException format:@"Required type is missing on injected dictionary parameter!"];
    }
    id <TyphoonDictionary> dictionary = [self dictionaryWithClass:self.requiredClass withResolvedInjectionsWithFactory:factory args:args];

    [invocation setArgument:&dictionary atIndex:self.parameterIndex + 2];
}


@end
