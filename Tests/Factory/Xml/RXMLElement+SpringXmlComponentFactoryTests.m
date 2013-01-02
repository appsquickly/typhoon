////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "SpringBundleResource.h"
#import "SpringComponentDefinition.h"
#import "RXMLElement+SpringXmlComponentFactory.h"


@interface RXMLElement_SpringXmlComponentFactoryTests : SenTestCase
@end

@implementation RXMLElement_SpringXmlComponentFactoryTests
{
    RXMLElement* _element;
}

- (void)setUp
{
    NSString* xmlString = [SpringBundleResource withName:@"MiddleAgesAssembly.xml"];
    LogDebug(@"Xml string: %@", xmlString);
    _element = [RXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];
}

- (void)test_asComponentDefinition
{
    NSMutableArray* componentDefinitions = [[NSMutableArray alloc] init];


    [_element iterate:@"*" usingBlock:^(RXMLElement* child)
    {
        if ([[child tag] isEqualToString:@"component"])
        {
            SpringComponentDefinition* definition = [child asComponentDefinition];
            LogDebug(@"Here's the component definition: %@", definition);
            [componentDefinitions addObject:definition];
        }
    }];

    assertThat(componentDefinitions, hasCountOf(4));
}


@end
