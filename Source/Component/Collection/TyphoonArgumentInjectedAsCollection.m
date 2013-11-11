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

#import "TyphoonArgumentInjectedAsCollection.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonDefinition.h"
#import "TyphoonTypeConvertedCollectionValue.h"
#import "TyphoonByReferenceCollectionValue.h"

@implementation TyphoonArgumentInjectedAsCollection

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self)
    {
        _values = [[NSMutableArray alloc] init];
    }
    return self;
}


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

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

- (NSArray*)values
{
    return [_values copy];
}

/* ====================================================================================================================================== */
#pragma mark - Utility Methods

- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@", _values=%@", _values];
    [description appendString:@">"];
    return description;
}

@end
