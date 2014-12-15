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


#import "TyphoonInjectionByCollection.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjections.h"
#import "TyphoonPropertyInjection.h"
#import "NSArray+TyphoonManualEnumeration.h"
#import "TyphoonUtils.h"

@interface TyphoonInjectionByCollection ()

@property(nonatomic, strong) NSMutableArray *injections;
@property(nonatomic) Class requiredClass;

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

+ (Class)collectionMutableClassFromClass:(Class)collectionClass
{
    Class result;

    if ([collectionClass isSubclassOfClass:[NSArray class]]) {
        result = [NSMutableArray class];
    }
    else if ([collectionClass isSubclassOfClass:[NSSet class]]) {
        result = [NSMutableSet class];
    }
    else if ([collectionClass isSubclassOfClass:[NSOrderedSet class]]) {
        result = [NSMutableOrderedSet class];
    }
    else {
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

- (instancetype)initWithCollection:(id <TyphoonCollection>)collection
{
    self = [super init];
    if (self) {
        self.injections = [[NSMutableArray alloc] initWithCapacity:[collection count]];

        for (id object in collection) {
            [self.injections addObject:TyphoonMakeInjectionFromObjectIfNeeded(object)];
        }
    }
    return self;
}

- (NSUInteger)count
{
    return [self.injections count];
}

#pragma mark - Utils

- (void)buildCollectionWithClass:(Class)collectionClass context:(TyphoonInjectionContext *)valuesContext completion:(void(^)(id<TyphoonCollection>collection))completion
{
    Class mutableClass = [TyphoonInjectionByCollection collectionMutableClassFromClass:collectionClass];
    id <TyphoonCollection> result = [[[mutableClass class] alloc] initWithCapacity:[self.injections count]];
    
    [self.injections typhoon_enumerateObjectsWithManualIteration:^(id<TyphoonInjection> object, id<TyphoonIterator> iterator) {
        [object valueToInjectWithContext:valuesContext completion:^(id value) {
            [result addObject:value];
            [iterator next];
        }];
    } completion:^{
        completion(result);
    }];
}

- (Class)collectionClassForContext:(TyphoonInjectionContext *)context
{
    Class collectionClass = self.requiredClass;
    if (!collectionClass) {
        collectionClass = context.destinationType.classOrProtocol;
    }
    if (![TyphoonInjectionByCollection isCollectionClass:collectionClass]) {
        [NSException raise:NSInvalidArgumentException format:@"Destination type '%@' is neither an NSSet nor NSArray.", NSStringFromClass(collectionClass)];
    }
    return collectionClass;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByCollection *copied = [[TyphoonInjectionByCollection alloc] init];
    copied.injections = self.injections;
    copied.requiredClass = self.requiredClass;
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (BOOL)isEqualToCustom:(TyphoonInjectionByCollection *)injection
{
    return [self.injections isEqualToArray:injection.injections] && self.requiredClass == injection.requiredClass;
}

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    Class collectionClass = [self collectionClassForContext:context];
    
    TyphoonInjectionContext *contextForValues = [context copy];
    contextForValues.destinationType = [TyphoonTypeDescriptor descriptorWithEncodedType:@encode(id)];
    
    [self buildCollectionWithClass:collectionClass context:contextForValues completion:^(id<TyphoonCollection> collection) {
        result(collection);
    }];
}

- (NSUInteger)customHash
{
    return TyphoonHashByAppendingInteger([self.injections hash], [_requiredClass hash]);
}

@end
