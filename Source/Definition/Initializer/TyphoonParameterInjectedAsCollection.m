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

#import "TyphoonParameterInjectedAsCollection.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"

@implementation TyphoonParameterInjectedAsCollection
{
    Class _requiredType;
    TyphoonInjectedAsCollectionImpl* _collection;
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithParameterIndex:(NSUInteger)index requiredType:(Class)requiredType
{
    self = [super init];
    if (self)
    {
        _index = index;
        _requiredType = requiredType;
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

- (TyphoonCollectionType)collectionType
{

    Class clazz = _requiredType;
    if (clazz == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Required type is missing on injected collection parameter!"];
    }
    if ([clazz isSubclassOfClass:[NSMutableArray class]])
    {
        return TyphoonCollectionTypeNSMutableArray;
    }
    else if ([clazz isSubclassOfClass:[NSArray class]])
    {
        return TyphoonCollectionTypeNSArray;
    }
    else if ([clazz isSubclassOfClass:[NSCountedSet class]])
    {
        return TyphoonCollectionTypeNSCountedSet;
    }
    else if ([clazz isSubclassOfClass:[NSMutableSet class]])
    {
        return TyphoonCollectionTypeNSMutableSet;
    }
    else if ([clazz isSubclassOfClass:[NSSet class]])
    {
        return TyphoonCollectionTypeNSSet;
    }

    [NSException raise:NSInvalidArgumentException format:@"Required collection type '%@' is neither an NSSet nor NSArray.",
                                                         NSStringFromClass(clazz)];
    return 0;
}


/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (void)withFactory:(TyphoonComponentFactory*)factory setArgumentOnInvocation:(NSInvocation*)invocation
{
    id collection = [self withFactory:factory newInstanceOfType:self.collectionType];
    [invocation setArgument:&collection atIndex:_index + 2];
}


@end
