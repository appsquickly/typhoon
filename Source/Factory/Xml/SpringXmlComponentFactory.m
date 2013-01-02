////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "SpringXmlComponentFactory.h"
#import "SpringBundleResource.h"
#import "RXMLElement+SpringXmlComponentFactory.h"


@implementation SpringXmlComponentFactory

/* ============================================================ Initializers ============================================================ */
- (id)initWithConfigFileName:(NSString*)configFileName
{
    return [self initWithConfigFileNames:configFileName, nil];
}

- (id)initWithConfigFileNames:(NSString*)configFileName, ...
{
    self = [super init];
    if (self)
    {

        va_list xml_list;
        _resourceNames = [NSMutableArray arrayWithObject:configFileName];

        va_start(xml_list, configFileName);
        NSString* resourceName;
        while ((resourceName = va_arg( xml_list, NSString *)))
        {
            [_resourceNames addObject:resourceName];
        }
        va_end(xml_list);
        [self parseComponentDefinitions];
    }
    return self;
}


/* ============================================================ Private Methods ========================================================= */
- (void)parseComponentDefinitions
{
    for (NSString* resourceName in _resourceNames)
    {
        NSString* xmlString = [SpringBundleResource withName:resourceName];
        RXMLElement* element = [RXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];

        [element iterate:@"*" usingBlock:^(RXMLElement* child)
        {
            if ([[child tag] isEqualToString:@"component"])
            {
                [self register:[child asComponentDefinition]];
            }
        }];
    }
}


@end