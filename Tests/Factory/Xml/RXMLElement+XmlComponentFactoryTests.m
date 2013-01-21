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
#import "Typhoon.h"

@interface RXMLElement_SpringXmlComponentFactoryTests : SenTestCase
@end

@implementation RXMLElement_SpringXmlComponentFactoryTests
{
    TyphoonRXMLElement* _element;
}

- (void)setUp
{
    NSString* xmlString = [[TyphoonBundleResource withName:@"MiddleAgesAssembly.xml"] asString];
    NSLog(@"Xml string: %@", xmlString);
    _element = [TyphoonRXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];
}

- (void)test_asComponentDefinition
{
    NSMutableArray* componentDefinitions = [[NSMutableArray alloc] init];


    [_element iterate:@"*" usingBlock:^(TyphoonRXMLElement* child)
    {
        if ([[child tag] isEqualToString:@"component"])
        {
            TyphoonDefinition* definition = [child asComponentDefinition];
            NSLog(@"Here's the component definition: %@", definition);
            [componentDefinitions addObject:definition];
        }
    }];

    assertThat(componentDefinitions, hasCountOf(6));
}


@end
