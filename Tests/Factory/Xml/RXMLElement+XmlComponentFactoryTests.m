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

    assertThat(componentDefinitions, hasCountOf(9));
}

- (void)test_asComponentDefinition_raises_exception_for_invalid_class_name
{
    @try
    {
        NSString* xmlString = [[TyphoonBundleResource withName:@"AssemblyWithInvalidClassName.xml"] asString];
        _element = [TyphoonRXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];
        [_element iterate:@"*" usingBlock:^(TyphoonRXMLElement* child)
        {
            if ([[child tag] isEqualToString:@"component"])
            {
                TyphoonDefinition* definition = [child asComponentDefinition];
                NSLog(@"Definition: %@", definition); //suppress unused variable warning
                STFail(@"Should have thrown exception");
            }
        }];

    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(@"Class 'AClassThatDoesNotExist' can't be resolved."));
    }

}


@end
