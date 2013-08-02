//
//  TyphoonAssemblySelectorWrapperTests.m
//  Tests
//
//  Created by Robert Gilliam on 8/1/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import <TyphoonAssemblySelectorWrapper.h>

@interface TyphoonAssemblySelectorWrapperTests : SenTestCase

@end



@implementation TyphoonAssemblySelectorWrapperTests {
    NSString *key;
    SEL unwrappedSEL;
    SEL wrappedSEL;
    
    SEL unwrappedSELWithArguments;
    SEL wrappedSELWithArguments;
}

- (void)setUp
{
    unwrappedSEL = @selector(uppercaseString);
    key = NSStringFromSelector(unwrappedSEL);
    wrappedSEL = [TyphoonAssemblySelectorWrapper wrappedSELForSEL:unwrappedSEL];
    
    unwrappedSELWithArguments = @selector(initWithString:attributes:);
    
}

- (void)testSelectorWithNoArgumentsValidAfterTransformation;
{
    [self wrappedSELShouldHaveNoArguments];
}

- (void)test_recognizes_wrapped;
{
    STAssertFalse([TyphoonAssemblySelectorWrapper selectorIsWrapped:unwrappedSEL], nil);
    STAssertTrue([TyphoonAssemblySelectorWrapper selectorIsWrapped:wrappedSEL], nil);
}

- (void)test_key_is_unwrapped_selector_as_string;
{
    assertThat([TyphoonAssemblySelectorWrapper keyForWrappedSEL:wrappedSEL], equalTo(key));
}

- (void)test_wrapped_SEL_for_key;
{
    STAssertEquals([TyphoonAssemblySelectorWrapper wrappedSELForKey:key], wrappedSEL, nil);
}

- (void)test_selector_with_arguments_preserves_arguments;
{
    wrappedSELWithArguments = [TyphoonAssemblySelectorWrapper wrappedSELForSEL:unwrappedSELWithArguments];
    [self wrappedSELWithArgumentsShouldHaveTwoArgumentsAndEndWithAnArgument];
}

- (void)wrappedSELShouldHaveNoArguments;
{
    STAssertEquals([self numberOfArgumentsInSelector:wrappedSEL], (NSUInteger)0, @"The wrapped SEL should not have any arguments.");
}

- (void)wrappedSELWithArgumentsShouldHaveTwoArgumentsAndEndWithAnArgument;
{
    assertThatUnsignedInteger([self numberOfArgumentsInSelector:wrappedSELWithArguments], equalToUnsignedInteger(2));
    STAssertEquals([self numberOfArgumentsInSelector:wrappedSELWithArguments], (NSUInteger)2, @"The wrapped SEL with two arguments should have two arguments.");
    STAssertTrue([self selectorEndsWithASemicolon:wrappedSELWithArguments], nil);
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
