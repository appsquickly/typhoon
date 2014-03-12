//
//  TyphoonInjectionByCollection.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByCollection.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectiveNSObject.h"

#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjections.h"
#import "TyphoonPropertyInjection.h"

@interface TyphoonInjectionByCollection ()

@property (nonatomic, strong) id<TyphoonCollection> collectionWithInjections;
@property (nonatomic) Class requiredClass;

@end

@implementation TyphoonInjectionByCollection

+ (Class) collectionMutableClassFromClass:(Class)collectionClass
{
    Class result;
    
    if (collectionClass == [NSArray class]) {
        result = [NSMutableArray class];
    } else if (collectionClass == [NSSet class]) {
        result = [NSMutableSet class];
    } else if (collectionClass == [NSOrderedSet class]) {
        result = [NSMutableOrderedSet class];
    } else {
        result = collectionClass;
    }
    
    return result;
}

- (instancetype)initWithCollection:(id)collection requiredClass:(Class)collectionClass
{
    self.requiredClass = collectionClass;

    return [self initWithCollection:collection];
}

- (instancetype)initWithCollection:(id<TyphoonCollection>)collection
{
    self = [super init];
    if (self) {
        Class mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:[collection class]];

        self.collectionWithInjections = [[mutableClass alloc] initWithCapacity:[collection count]];
        
        for (id object in collection) {
            
            id injection = nil;
            
            if ([object conformsToProtocol:@protocol(TyphoonObjectWithCustomInjection)]) {
                injection = [object typhoonCustomObjectInjection];
            } else if ([object conformsToProtocol:@protocol(TyphoonPropertyInjection)]) {
                injection = object;
            } else {
                injection = TyphoonInjectionWithObject(object);
            }
            
            [self.collectionWithInjections addObject:injection];
            
        }
    }
    return self;
}

- (id<TyphoonCollection>)collectionWithClass:(Class)collectionClass withResolvedInjectionsWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    Class mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:collectionClass];
    id<TyphoonCollection> result = [[[mutableClass class] alloc] initWithCapacity:[self.collectionWithInjections count]];
    
    for (id<TyphoonPropertyInjection>injection in self.collectionWithInjections) {
        id value = [injection valueToInjectPropertyOnInstance:nil withFactory:factory args:args];
        [result addObject:value];
    }
    
    return result;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByCollection *copied = [[TyphoonInjectionByCollection alloc] init];
    copied.collectionWithInjections = self.collectionWithInjections;
    [self copyBaseProperiesTo:copied];
    return copied;
}

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    Class collectionClass = self.requiredClass;
    if (!collectionClass) {
        TyphoonTypeDescriptor *type = [instance typeForPropertyWithName:self.propertyName];
        collectionClass = type.classOrProtocol;
    }
    return [self collectionWithClass:collectionClass withResolvedInjectionsWithFactory:factory args:args];
}

- (void)setArgumentOnInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    if (!self.requiredClass) {
        [NSException raise:NSInvalidArgumentException format:@"Required type is missing on injected collection parameter!"];
    }
    
    id<TyphoonCollection> collection = [self collectionWithClass:self.requiredClass withResolvedInjectionsWithFactory:factory args:args];
    [invocation setArgument:&collection atIndex:self.parameterIndex + 2];
}


@end
