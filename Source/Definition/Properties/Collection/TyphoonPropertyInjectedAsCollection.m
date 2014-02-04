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
#import "TyphoonTypeConvertedCollectionValue.h"


@implementation TyphoonPropertyInjectedAsCollection


/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithName:(NSString*)name
{
    self = [super init];
    if (self)
    {
        _name = name;
    }
    return self;
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


- (TyphoonPropertyInjectionType)injectionType
{
    return TyphoonPropertyInjectionTypeAsCollection;
}


@end
