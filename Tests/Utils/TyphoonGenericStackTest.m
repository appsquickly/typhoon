//
//  TyphoonGenericStackTest.m
//  Tests
//
//  Created by César Estébanez Tascón on 9/28/13.
//
//

#import <SenTestingKit/SenTestingKit.h>

#import "TyphoonGenericStack.h"

@interface TyphoonGenericStackTest : SenTestCase

@end

@implementation TyphoonGenericStackTest

- (void)testPopReturnsTopOfStack
{
    // given
    TyphoonGenericStack *sut = [TyphoonGenericStack stack];
    [sut push:@1];
    
    // when
    id topOfStack = [sut pop];
    
    // then
    assertThat(topOfStack, is(@1));
}

- (void) testPopRemovesTopOfStack
{
    // given
    TyphoonGenericStack *sut = [TyphoonGenericStack stack];
    [sut push:@1];
    
    // when
    [sut pop];
    
    // then
    assertThatBool([sut isEmpty], is(equalToBool(YES)));
}

- (void)testPopOnEmptyStackReturnsNil
{
    // given
    TyphoonGenericStack *sut = [TyphoonGenericStack stack];
    
    // when
    id topOfStack = [sut pop];
    
    // then
    assertThat(topOfStack, is(nilValue()));
}

@end
