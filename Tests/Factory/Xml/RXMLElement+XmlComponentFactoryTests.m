////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import "Typhoon.h"

@interface RXMLElement_SpringXmlComponentFactoryTests : SenTestCase

@property(nonatomic, strong) TyphoonRXMLElement* lazyElementTest;

@end

@implementation RXMLElement_SpringXmlComponentFactoryTests
{
    TyphoonRXMLElement* _element;
}

- (void)setUp
{
    NSString* xmlString = [[TyphoonBundleResource withName:@"MiddleAgesAssembly.xml"] asString];
    _element = [TyphoonRXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];

    NSString* lasyXmlString = [[TyphoonBundleResource withName:@"LazyInitCasesAssembly.xml"] asString];
    self.lazyElementTest = [TyphoonRXMLElement elementFromXMLString:lasyXmlString encoding:NSUTF8StringEncoding];
}

- (void)tearDown
{
    self.lazyElementTest = nil;
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

    assertThat(componentDefinitions, hasCountOf(10));
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


- (TyphoonDefinition*)definitionInElement:(TyphoonRXMLElement*)elt forKey:(NSString*)key
{
    NSArray* components = [elt children:@"component"];
    NSUInteger index = [components indexOfObjectPassingTest:^BOOL(TyphoonRXMLElement* child, NSUInteger idx, BOOL* stop)
    {
        return [[child attribute:@"key"] isEqual:key];
    }];
    return (index != NSNotFound) ? [[components objectAtIndex:index] asComponentDefinition] : nil;
}

- (void)test_asComponentDefinition_lazyInit_prototype_with_lazy_true
{
    TyphoonDefinition* def = [self definitionInElement:[self lazyElementTest] forKey:@"prototype1"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_prototype_with_lazy_false
{
    TyphoonDefinition* def = [self definitionInElement:[self lazyElementTest] forKey:@"prototype2"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_singleton_with_lazy_true
{
    TyphoonDefinition* def = [self definitionInElement:[self lazyElementTest] forKey:@"lazySingleton1"];
    assertThatUnsignedInt([def scope], is(@(TyphoonScopeSingleton)));
    assertThatBool([def isLazy], is(@YES));
}

- (void)test_asComponentDefinition_lazyInit_singleton_with_lazy_false
{
    TyphoonDefinition* def = [self definitionInElement:[self lazyElementTest] forKey:@"singleton1"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_singleton_with_wrong_lazy
{
    TyphoonDefinition* def = [self definitionInElement:[self lazyElementTest] forKey:@"singleton2"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_singleton_without_lazy
{
    TyphoonDefinition* def = [self definitionInElement:[self lazyElementTest] forKey:@"singleton3"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_singleton_with_lazy_YES
{
    TyphoonDefinition* def = [self definitionInElement:[self lazyElementTest] forKey:@"lazySingleton2"];
    assertThatBool([def isLazy], is(@YES));
}


@end
