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

@implementation TyphoonParameterInjectedAsCollection {
    Class _requiredType;
}

-(id)initWithParameterIndex:(NSUInteger)index requiredType:(Class)requiredType
{
    self = [super init];
    if (self)
    {
        _index = index;
        _requiredType = requiredType;
    }
    return self;
}

- (TyphoonParameterInjectionType)type
{
  return TyphoonParameterInjectionTypeAsCollection;
}

-(void)setInitializer:(TyphoonInitializer *)initializer
{
  // No-op.
}

-(TyphoonCollectionType)collectionType {
    
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
    return nil;
}

@end
