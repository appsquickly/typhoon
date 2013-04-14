////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonPropertyInjectedAsCollection.h"
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition.h"
#import "TyphoonTypeConvertedCollectionValue.h"
#import "TyphoonByReferenceCollectionValue.h"


@implementation TyphoonPropertyInjectedAsCollection


/* ============================================================ Initializers ============================================================ */
- (id)initWithName:(NSString*)name
{
    self = [super init];
    if (self)
    {
        _name = name;
        _values = [[NSMutableArray alloc] init];
    }
    return self;
}


/* ========================================================== Interface Methods ========================================================= */
- (void)addItemWithText:(NSString*)text requiredType:(Class)requiredType
{
    [_values addObject:[[TyphoonTypeConvertedCollectionValue alloc] initWithTextValue:text requiredType:requiredType]];
}

- (void)addItemWithComponentName:(NSString*)componentName
{
    [_values addObject:[[TyphoonByReferenceCollectionValue alloc] initWithComponentName:componentName]];
}

- (void)addItemWithDefinition:(TyphoonDefinition*)definition
{
    [_values addObject:[[TyphoonByReferenceCollectionValue alloc] initWithComponentName:definition.key]];
}

- (TyphoonCollectionType)resolveCollectionTypeGiven:(Class)clazz
{
    TyphoonTypeDescriptor* descriptor = [TyphoonIntrospectionUtils typeForPropertyWithName:_name inClass:clazz];
    Class describedClass = (Class) [descriptor classOrProtocol];
    if (describedClass == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Property named '%@' does not exist on class '%@'.", _name,
                                                             NSStringFromClass(clazz)];
    }
    if (describedClass == [NSArray class])
    {
        return TyphoonCollectionTypeNSArray;
    }
    else if ([describedClass isSubclassOfClass:[NSArray class]])
    {
        return TyphoonCollectionTypeNSMutableArray;
    }
    else if (describedClass == [NSSet class])
    {
        return TyphoonCollectionTypeNSSet;
    }
    else if ([describedClass isSubclassOfClass:[NSSet class]])
    {
        return TyphoonCollectionTypeNSMutableSet;
    }
    [NSException raise:NSInvalidArgumentException format:@"Property named '%@' on '%@' is neither an NSSet nor NSArray.", _name,
                                                         NSStringFromClass(describedClass)];
    return nil;
}

/* =========================================================== Protocol Methods ========================================================= */
#pragma mark - <TyphoonInjectedProperty>

- (NSString*)name
{
    return _name;
}

- (TyphoonPropertyInjectionType)injectionType
{
    return TyphoonPropertyInjectionAsCollection;
}


@end