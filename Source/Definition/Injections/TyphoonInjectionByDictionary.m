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
#import "TyphoonTypeDescriptor.h"
#import "NSArray+TyphoonManualEnumeration.h"

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

- (NSUInteger)count
{
    return [self.injections count];
}

#pragma mark - Utils

- (void)buildDictionaryWithClass:(Class)dictionaryClass context:(TyphoonInjectionContext *)valuesContext completion:(void(^)(id<TyphoonDictionary>dictionary))completion
{
    Class mutableClass = [TyphoonInjectionByDictionary dictionaryMutableClassFromClass:dictionaryClass];
    id <TyphoonDictionary> result = [[[mutableClass class] alloc] initWithCapacity:[self.injections count]];
    
    [[self.injections allKeys] typhoon_enumerateObjectsWithManualIteration:^(id key, id<TyphoonIterator> iterator) {
        [self.injections[key] valueToInjectWithContext:valuesContext completion:^(id value) {
            [result setObject:value forKey:key];
            [iterator next];
        }];
    } completion:^{
        completion(result);
    }];
}

- (Class)dictionaryClassForContext:(TyphoonInjectionContext *)context
{
    Class dictionaryClass = self.requiredClass;
    if (!dictionaryClass) {
        dictionaryClass = context.destinationType.classOrProtocol;
    }
    if (![TyphoonInjectionByDictionary isDictionaryClass:dictionaryClass]) {
        [NSException raise:NSInvalidArgumentException format:@"Property named '%@' on '%@' is not dictionary.", self.propertyName,
         NSStringFromClass(dictionaryClass)];
    }
    return dictionaryClass;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByDictionary *copied = [[TyphoonInjectionByDictionary alloc] init];
    copied.injections = self.injections;
    copied.requiredClass = self.requiredClass;
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    Class dictionaryClass = [self dictionaryClassForContext:context];
    
    TyphoonInjectionContext *contextForValues = [context copy];
    contextForValues.destinationType = [TyphoonTypeDescriptor descriptorWithEncodedType:@encode(id)];
    
    [self buildDictionaryWithClass:dictionaryClass context:contextForValues completion:^(id<TyphoonDictionary> dictionary) {
        result(dictionary);
    }];
}

@end
