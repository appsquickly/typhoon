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
#import "TyphoonTypeConvertedCollectionValue.h"
#import "TyphoonByReferenceCollectionValue.h"


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

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods
#pragma mark - <TyphoonInjectedProperty>

- (NSString*)name
{
    return _name;
}

- (TyphoonPropertyInjectionType)injectionType
{
    return TyphoonPropertyInjectionTypeAsCollection;
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.name=%@", self.name];
    [description appendFormat:@", _values=%@", _values];
    [description appendString:@">"];
    return description;
}


@end
