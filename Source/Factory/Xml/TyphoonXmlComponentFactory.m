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


#import "TyphoonXmlComponentFactory.h"
#import "TyphoonBundleResource.h"
#import "TyphoonRXMLElement+XmlComponentFactory.h"


@implementation TyphoonXmlComponentFactory

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithConfigFileName:(NSString *)configFileName
{
    return [self initWithConfigFileNames:configFileName, nil];
}

- (id)initWithConfigFileNames:(NSString *)configFileName, ...
{
    self = [super init];
    if (self) {
        va_list xml_list;
        _resourceNames = [NSMutableArray arrayWithObject:configFileName];

        va_start(xml_list, configFileName);
        NSString *resourceName;
        while ((resourceName = va_arg( xml_list, NSString *))) {
            [_resourceNames addObject:resourceName];
        }
        va_end(xml_list);
        [self parseComponentDefinitions];
    }
    return self;
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)parseComponentDefinitions
{
    for (NSString *resourceName in _resourceNames) {
        NSString *xmlString = [[TyphoonBundleResource withName:resourceName] asString];
        TyphoonRXMLElement *element = [TyphoonRXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];

        [element iterate:@"*" usingBlock:^(TyphoonRXMLElement *child) {
            if ([child isComponent]) {
                [self registerDefinition:[child asComponentDefinition]];
            }
        }];
    }
}


@end
