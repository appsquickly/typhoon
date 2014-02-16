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


#import "TyphoonPropertyInjectedAsCollection.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"

@interface TyphoonPropertyInjectedAsCollection ()

@property(nonatomic, strong, readwrite) TyphoonInjectedAsCollection *collection;

@end

@implementation TyphoonPropertyInjectedAsCollection

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
        _collection = [[TyphoonInjectedAsCollection alloc] init];
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods
#pragma mark - <TyphoonInjectedAsCollection>

- (void)addItemWithText:(NSString *)text requiredType:(Class)requiredType
{
    [_collection addItemWithText:text requiredType:requiredType];
}

- (void)addItemWithComponentName:(NSString *)componentName
{
    [_collection addItemWithComponentName:componentName];
}

- (void)addItemWithDefinition:(TyphoonDefinition *)definition
{
    [_collection addItemWithDefinition:definition];
}

- (void)addValue:(id <TyphoonCollectionValue>)value
{
    [_collection addValue:value];
}

- (NSArray *)values
{
    return [_collection values];
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (TyphoonCollectionType)resolveCollectionTypeWith:(id <TyphoonIntrospectiveNSObject>)instance;
{
    TyphoonTypeDescriptor *descriptor = [TyphoonIntrospectionUtils typeForPropertyWithName:_name inClass:[instance class]];
    Class describedClass = (Class) [descriptor classOrProtocol];
    if (describedClass == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Property named '%@' does not exist on class '%@'.", _name,
                                                             NSStringFromClass([instance class])];
    }
    if ([describedClass isSubclassOfClass:[NSMutableArray class]]) {
        return TyphoonCollectionTypeNSMutableArray;
    }
    else if ([describedClass isSubclassOfClass:[NSArray class]]) {
        return TyphoonCollectionTypeNSArray;
    }
    else if ([describedClass isSubclassOfClass:[NSCountedSet class]]) {
        return TyphoonCollectionTypeNSCountedSet;
    }
    else if ([describedClass isSubclassOfClass:[NSMutableSet class]]) {
        return TyphoonCollectionTypeNSMutableSet;
    }
    else if ([describedClass isSubclassOfClass:[NSSet class]]) {
        return TyphoonCollectionTypeNSSet;
    }

    [NSException raise:NSInvalidArgumentException format:@"Property named '%@' on '%@' is neither an NSSet nor NSArray.", _name,
                                                         NSStringFromClass(describedClass)];
    return 0;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (id)withFactory:(TyphoonComponentFactory *)factory computeValueToInjectOnInstance:(id)instance
{
    TyphoonCollectionType type = [self resolveCollectionTypeWith:instance];
    return [_collection withFactory:factory newCollectionOfType:type];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonPropertyInjectedAsCollection *copy = [[TyphoonPropertyInjectedAsCollection alloc] initWithName:[_name copy]];
    [copy setValue:[_collection copy] forKey:@"collection"];
    return copy;
}


@end
