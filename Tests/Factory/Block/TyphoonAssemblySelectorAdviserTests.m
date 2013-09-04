//
//  TyphoonAssemblySelectorAdviserTests.m
//  Tests
//
//  Created by Robert Gilliam on 8/1/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import <TyphoonAssemblySelectorAdviser.h>

@interface TyphoonAssemblySelectorAdviserTests : SenTestCase

@end



@implementation TyphoonAssemblySelectorAdviserTests {
    NSString* key;
    SEL sel;
    SEL advisedSEL;
    
    SEL SELWithArguments;
    SEL advisedSELWithArguments;
}

- (void)setUp
{
    sel = @selector(uppercaseString);
    key = NSStringFromSelector(sel);
    advisedSEL = [TyphoonAssemblySelectorAdviser advisedSELForSEL:sel];
    
    SELWithArguments = @selector(initWithString:attributes:);
}

- (void)test_selector_with_no_arguments_valid_after_transformation;
{
    [self advisedSELShouldHaveNoArguments];
}

- (void)test_recognizes_advised;
{
    STAssertFalse([TyphoonAssemblySelectorAdviser selectorIsAdvised:sel], nil);
    STAssertTrue([TyphoonAssemblySelectorAdviser selectorIsAdvised:advisedSEL], nil);
}

- (void)test_key_is_selector_as_string;
{
    assertThat([TyphoonAssemblySelectorAdviser keyForAdvisedSEL:advisedSEL], equalTo(key));
}

- (void)test_advised_SEL_for_key;
{
    STAssertEquals([TyphoonAssemblySelectorAdviser advisedSELForKey:key], advisedSEL, nil);
}

- (void)test_selector_with_arguments_preserves_arguments;
{
    advisedSELWithArguments = [TyphoonAssemblySelectorAdviser advisedSELForSEL:SELWithArguments];
    [self advisedSELWithArgumentsShouldHaveTwoArgumentsAndEndWithAnArgument];
}

- (void)advisedSELShouldHaveNoArguments;
{
    STAssertEquals([self numberOfArgumentsInSelector:advisedSEL], (NSUInteger)0, @"The advised SEL should not have any arguments.");
}

- (void)advisedSELWithArgumentsShouldHaveTwoArgumentsAndEndWithAnArgument;
{
    assertThatUnsignedInteger([self numberOfArgumentsInSelector:advisedSELWithArguments], equalToUnsignedInteger(2));
    STAssertEquals([self numberOfArgumentsInSelector:advisedSELWithArguments], (NSUInteger)2, @"The wrapped SEL with two arguments should have two arguments.");
    STAssertTrue([self selectorEndsWithASemicolon:advisedSELWithArguments], nil);
}

- (NSUInteger)numberOfArgumentsInSelector:(SEL)selector;
{
    NSString *original = NSStringFromSelector(selector);
    NSString *withArgumentsRemoved = [original stringByReplacingOccurrencesOfString:@":" withString:@""];
    return [original length] - [withArgumentsRemoved length];
}

- (BOOL)selectorEndsWithASemicolon:(SEL)selector;
{
    NSString *s = NSStringFromSelector(selector);
    NSUInteger lastIndex = [s length] - 1;
    return [[s substringFromIndex:lastIndex] isEqualToString:@":"];
}

@end
