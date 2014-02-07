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
#import "TyphoonInjectedAsCollectionImpl.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"


@implementation TyphoonPropertyInjectedAsCollection
{
    TyphoonInjectedAsCollectionImpl* _collection;
}


/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithName:(NSString*)name
{
    self = [super init];
    if (self)
    {
        _name = name;
        _collection = [[TyphoonInjectedAsCollectionImpl alloc] init];
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods

- (void)addItemWithText:(NSString*)text requiredType:(Class)requiredType
{
    [_collection addItemWithText:text requiredType:requiredType];
}

- (void)addItemWithComponentName:(NSString*)componentName
{
    [_collection addItemWithComponentName:componentName];
}

- (void)addItemWithDefinition:(TyphoonDefinition*)definition
{
    [_collection addItemWithDefinition:definition];
}

- (NSArray*)values
{
    return [_collection values];
}

- (id)withFactory:(TyphoonComponentFactory*)factory newInstanceOfType:(TyphoonCollectionType)type
{
    return [_collection withFactory:factory newInstanceOfType:type];
}


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (TyphoonCollectionType)resolveCollectionTypeWith:(id <TyphoonIntrospectiveNSObject>)instance;
{
    TyphoonTypeDescriptor* descriptor = [TyphoonIntrospectionUtils typeForPropertyWithName:_name inClass:[instance class]];
    Class describedClass = (Class) [descriptor classOrProtocol];
    if (describedClass == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Property named '%@' does not exist on class '%@'.", _name,
                                                             NSStringFromClass([instance class])];
    }
    if ([describedClass isSubclassOfClass:[NSMutableArray class]])
    {
        return TyphoonCollectionTypeNSMutableArray;
    }
    else if ([describedClass isSubclassOfClass:[NSArray class]])
    {
        return TyphoonCollectionTypeNSArray;
    }
    else if ([describedClass isSubclassOfClass:[NSCountedSet class]])
    {
        return TyphoonCollectionTypeNSCountedSet;
    }
    else if ([describedClass isSubclassOfClass:[NSMutableSet class]])
    {
        return TyphoonCollectionTypeNSMutableSet;
    }
    else if ([describedClass isSubclassOfClass:[NSSet class]])
    {
        return TyphoonCollectionTypeNSSet;
    }

    [NSException raise:NSInvalidArgumentException format:@"Property named '%@' on '%@' is neither an NSSet nor NSArray.", _name,
                                                         NSStringFromClass(describedClass)];
    return 0;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (id)withFactory:(TyphoonComponentFactory*)factory computeValueToInjectOnInstance:(id)instance
{
    TyphoonCollectionType type = [self resolveCollectionTypeWith:instance];
    id collection = [self withFactory:factory newInstanceOfType:type];
    return collection;
}



@end
