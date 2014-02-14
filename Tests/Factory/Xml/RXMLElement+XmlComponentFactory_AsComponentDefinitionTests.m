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
#import "TyphoonTestXMLBuilder.h"

@interface RXMLElement_XmlComponentFactory_AsComponentDefinitionTests : SenTestCase

@property(nonatomic, strong) TyphoonRXMLElement *lazyElementTest;

@end

@implementation RXMLElement_XmlComponentFactory_AsComponentDefinitionTests {
    TyphoonRXMLElement *_element;
    TyphoonRXMLElement *_parentElement;
}

- (void)setUp {
    NSString *xmlString = [[TyphoonBundleResource withName:@"MiddleAgesAssembly.xml"] asString];
    _element = [TyphoonRXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];

    NSString *lasyXmlString = [[TyphoonBundleResource withName:@"XmlParsingCasesAssembly.xml"] asString];
    self.lazyElementTest = [TyphoonRXMLElement elementFromXMLString:lasyXmlString encoding:NSUTF8StringEncoding];
}

- (void)tearDown {
    self.lazyElementTest = nil;
}

- (void)test_asComponentDefinition {
    NSMutableArray *componentDefinitions = [[NSMutableArray alloc] init];
    [_element iterate:@"*" usingBlock:^(TyphoonRXMLElement *child) {
        if ([[child tag] isEqualToString:@"component"]) {
            TyphoonDefinition *definition = [child asComponentDefinition];
            [componentDefinitions addObject:definition];
        }
    }];

    assertThat(componentDefinitions, hasCountOf(10));
}

- (void)test_asComponentDefinition_raises_exception_for_invalid_class_name {
    @try {
        NSString *xmlString = [[TyphoonBundleResource withName:@"AssemblyWithInvalidClassName.xml"] asString];
        _element = [TyphoonRXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];
        [_element iterate:@"*" usingBlock:^(TyphoonRXMLElement *child) {
            if ([[child tag] isEqualToString:@"component"]) {

                TyphoonDefinition *definition = [child asComponentDefinition];
                NSLog(@"Definition: %@", definition); //suppress unused variable warning. TODO: replace with a warning suppressing pragma.
                STFail(@"Should have thrown exception");
            }
        }];

    }
    @catch (NSException *e) {
        assertThat([e description], equalTo(@"Class 'AClassThatDoesNotExist' can't be resolved."));
    }

}


- (TyphoonDefinition *)definitionInElement:(TyphoonRXMLElement *)elt forKey:(NSString *)key {
    NSArray *components = [elt children:@"component"];
    NSUInteger index = [components indexOfObjectPassingTest:^BOOL(TyphoonRXMLElement *child, NSUInteger idx, BOOL *stop) {
        return [[child attribute:@"key"] isEqual:key];
    }];
    return (index != NSNotFound) ? [[components objectAtIndex:index] asComponentDefinition] : nil;
}

- (void)test_asComponentDefinition_lazyInit_prototype_with_lazy_true {
    TyphoonDefinition *def = [self definitionInElement:[self lazyElementTest] forKey:@"prototype1"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_prototype_with_lazy_false {
    TyphoonDefinition *def = [self definitionInElement:[self lazyElementTest] forKey:@"prototype2"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_singleton_with_lazy_true {
    TyphoonDefinition *def = [self definitionInElement:[self lazyElementTest] forKey:@"lazySingleton1"];
    assertThatUnsignedInt([def scope], is(@(TyphoonScopeSingleton)));
    assertThatBool([def isLazy], is(@YES));
}

- (void)test_asComponentDefinition_lazyInit_object_graph {
    TyphoonDefinition *def = [self definitionInElement:[self lazyElementTest] forKey:@"lazySingleton1"];
    assertThatUnsignedInt([def scope], is(@(TyphoonScopeSingleton)));
    assertThatBool([def isLazy], is(@YES));
}

- (void)test_asComponentDefinition_lazyInit_singleton_with_lazy_false {
    TyphoonDefinition *def = [self definitionInElement:[self lazyElementTest] forKey:@"singleton1"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_singleton_with_wrong_lazy {
    TyphoonDefinition *def = [self definitionInElement:[self lazyElementTest] forKey:@"singleton2"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_singleton_without_lazy {
    TyphoonDefinition *def = [self definitionInElement:[self lazyElementTest] forKey:@"singleton3"];
    assertThatBool([def isLazy], is(@NO));
}

- (void)test_asComponentDefinition_lazyInit_singleton_with_lazy_YES {
    TyphoonDefinition *def = [self definitionInElement:[self lazyElementTest] forKey:@"defaultScope1"];
    assertThatUnsignedInteger([def scope], equalToUnsignedInteger(TyphoonScopeObjectGraph));
}

- (void)test_asComponentDefinition_default_scope {
    TyphoonDefinition *def = [self definitionInElement:[self lazyElementTest] forKey:@"lazySingleton2"];
    assertThatBool([def isLazy], is(@YES));
}

- (void)test_asComponentDefinition_no_parent {
    TyphoonRXMLElement *vanillaDefinitionXML = [[TyphoonTestXMLBuilder vanillaDefinition] build];

    TyphoonDefinition *def = [vanillaDefinitionXML asComponentDefinition];

    assertThat(def, notNilValue());
    assertThat([def parent], nilValue());
}

- (void)test_asComponentDefinition_parent {
    id parentRef = @"parent";
    TyphoonRXMLElement
        *childDefinitionXML = [[[TyphoonTestXMLBuilder vanillaDefinition] withAttribute:@"parent" textValue:parentRef] build];

    TyphoonDefinition *def = [childDefinitionXML asComponentDefinition];

    assertThat(def, notNilValue());
    assertThat([def parent], notNilValue());
}

@end
