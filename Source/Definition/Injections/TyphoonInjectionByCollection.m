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

@property (nonatomic, strong) NSMutableArray *arrayWithInjections;
@property (nonatomic) Class requiredClass;

@end



@implementation TyphoonInjectionByCollection

+ (BOOL)isCollectionClass:(Class)collectionClass
{
    collectionClass = [self collectionMutableClassFromClass:collectionClass];
    BOOL success = YES;
    success &= [collectionClass conformsToProtocol:@protocol(NSFastEnumeration)];
    success &= [collectionClass instancesRespondToSelector:@selector(initWithCapacity:)];
    success &= [collectionClass instancesRespondToSelector:@selector(count)];
    success &= [collectionClass instancesRespondToSelector:@selector(addObject:)];

    return success;
}

+ (Class) collectionMutableClassFromClass:(Class)collectionClass
{
    Class result;
    
    if ([collectionClass isSubclassOfClass:[NSArray class]]) {
        result = [NSMutableArray class];
    } else if ([collectionClass isSubclassOfClass:[NSSet class]]) {
        result = [NSMutableSet class];
    } else if ([collectionClass isSubclassOfClass:[NSOrderedSet class]]) {
        result = [NSMutableOrderedSet class];
    } else {
        result = collectionClass;
    }
    
    return result;
}

- (instancetype)initWithCollection:(id)collection requiredClass:(Class)collectionClass
{
    self.requiredClass = collectionClass;
    
    if (self.requiredClass && ![TyphoonInjectionByCollection isCollectionClass:self.requiredClass]) {
        [NSException raise:NSInvalidArgumentException format:@"Required collection type '%@' is neither an NSSet nor NSArray.",
         NSStringFromClass(self.requiredClass)];
    }

    return [self initWithCollection:collection];
}

- (instancetype)initWithCollection:(id<TyphoonCollection>)collection
{
    self = [super init];
    if (self) {
        self.arrayWithInjections = [[NSMutableArray alloc] initWithCapacity:[collection count]];
   
        for (id object in collection) {
            
            id injection = nil;
            
            if ([object conformsToProtocol:@protocol(TyphoonObjectWithCustomInjection)]) {
                injection = [object typhoonCustomObjectInjection];
            } else if ([object conformsToProtocol:@protocol(TyphoonPropertyInjection)]) {
                injection = object;
            } else {
                injection = TyphoonInjectionWithObject(object);
            }
            [self.arrayWithInjections addObject:injection];
            
        }
    }
    return self;
}

- (id<TyphoonCollection>)collectionWithClass:(Class)collectionClass withResolvedInjectionsWithFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    Class mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:collectionClass];
    id<TyphoonCollection> result = [[[mutableClass class] alloc] initWithCapacity:[self.arrayWithInjections count]];
    
    for (id<TyphoonPropertyInjection>injection in self.arrayWithInjections) {
        id value = [injection valueToInjectPropertyOnInstance:nil withFactory:factory args:args];
        [result addObject:value];
    }
    
    return result;
}

- (NSUInteger)count
{
    return [self.arrayWithInjections count];
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByCollection *copied = [[TyphoonInjectionByCollection alloc] init];
    copied.arrayWithInjections = self.arrayWithInjections;
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
    if (![TyphoonInjectionByCollection isCollectionClass:collectionClass]) {
        [NSException raise:NSInvalidArgumentException format:@"Property named '%@' on '%@' is neither an NSSet nor NSArray.", self.propertyName,
         NSStringFromClass(collectionClass)];
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
