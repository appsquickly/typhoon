////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2012 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "SpringPropertyPlaceholderConfigurer.h"


@implementation SpringPropertyPlaceholderConfigurer

/* =========================================================== Class Methods ============================================================ */
+ (SpringPropertyPlaceholderConfigurer*)configurer
{
    return [[SpringPropertyPlaceholderConfigurer alloc] initWithPrefix:@"${" suffix:@"}"];
}

/* ============================================================ Initializers ============================================================ */
- (id)initWithPrefix:(NSString*)aPrefix suffix:(NSString*)aSuffix
{
    self = [super init];
    if (self)
    {
        _prefix = aPrefix;
        _suffix = aSuffix;
        _propertyResources = [[NSMutableArray alloc] init];
    }
    return self;
}

/* ========================================================== Interface Methods ========================================================= */
- (void)usePropertyResource:(id <SpringResource>)resource
{
    [_propertyResources addObject:[resource asString];
}


/* =========================================================== Protocol Methods ========================================================= */
- (void)mutateComponentDefinitionsIfRequired:(NSArray*)componentDefinitions
{

}

@end