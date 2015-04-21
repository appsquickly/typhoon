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




#import "TyphoonLinkerCategoryBugFix.h"

TYPHOON_LINK_CATEGORY(NSObject_TyphoonIntrospectionUtils)

#import <objc/runtime.h>
#import "TyphoonTypeDescriptor.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonUtils.h"


@implementation NSObject (TyphoonIntrospectionUtils)

- (NSSet*)typhoonPropertiesUpToParentClass:(Class)clazz
{
    return [TyphoonIntrospectionUtils propertiesForClass:[self class] upToParentClass:clazz];
}

- (TyphoonTypeDescriptor *)typhoonTypeForPropertyNamed:(NSString *)propertyName
{
    return [TyphoonIntrospectionUtils typeForPropertyNamed:propertyName inClass:[self class]];
}

@end
