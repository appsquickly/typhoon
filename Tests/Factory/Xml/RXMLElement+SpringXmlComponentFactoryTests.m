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
#import "SpringRXMLElement+SpringXmlComponentFactory.h"


@interface RXMLElement_SpringXmlComponentFactoryTests : SenTestCase
@end

@implementation RXMLElement_SpringXmlComponentFactoryTests
{
    SpringRXMLElement* _element;
}

- (void)setUp
{
    NSString* xmlString = [SpringBundleResource withName:@"MiddleAgesAssembly.xml"];
    SpringDebug(@"Xml string: %@", xmlString);
    _element = [SpringRXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];
}

- (void)test_asComponentDefinition
{
    NSMutableArray* componentDefinitions = [[NSMutableArray alloc] init];


    [_element iterate:@"*" usingBlock:^(SpringRXMLElement* child)
    {
        if ([[child tag] isEqualToString:@"component"])
        {
            SpringComponentDefinition* definition = [child asComponentDefinition];
            SpringDebug(@"Here's the component definition: %@", definition);
            [componentDefinitions addObject:definition];
        }
    }];

    assertThat(componentDefinitions, hasCountOf(6));
}


@end
