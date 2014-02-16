////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
///////////////////////////////////////////////////////// ///////////////////////


#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonStringUtils.h"


@interface TyphoonStringUtilsTests : SenTestCase


@end


@implementation TyphoonStringUtilsTests

- (void)test_isAlpha
{
    assertThatBool([TyphoonStringUtils isAlpha:@"1234"], equalToBool(NO));
    assertThatBool([TyphoonStringUtils isAlpha:@"abc1234"], equalToBool(NO));

    assertThatBool([TyphoonStringUtils isAlpha:@"abc"], equalToBool(YES));
}

- (void)test_isAlphaOrSpaces
{
    assertThatBool([TyphoonStringUtils isAlphaOrSpaces:@"1234"], equalToBool(NO));
    assertThatBool([TyphoonStringUtils isAlphaOrSpaces:@"abc1234"], equalToBool(NO));

    assertThatBool([TyphoonStringUtils isAlphaOrSpaces:@"abc"], equalToBool(YES));
    assertThatBool([TyphoonStringUtils isAlphaOrSpaces:@"abc \t\n"], equalToBool(YES));
}

- (void)test_isAlphaNumeric
{
    assertThatBool([TyphoonStringUtils isAlphanumeric:@"1234"], equalToBool(YES));
    assertThatBool([TyphoonStringUtils isAlphanumeric:@"abc1234"], equalToBool(YES));

    assertThatBool([TyphoonStringUtils isAlphanumeric:@"abc \t\n"], equalToBool(NO));
}

- (void)test_isEmpty
{
    assertThatBool([TyphoonStringUtils isEmpty:@""], equalToBool(YES));
    assertThatBool([TyphoonStringUtils isEmpty:@"1234"], equalToBool(NO));
    assertThatBool([TyphoonStringUtils isEmpty:@" \t\n"], equalToBool(YES));
}

- (void)test_isNotEmpty
{
    assertThatBool([TyphoonStringUtils isNotEmpty:@""], equalToBool(NO));
    assertThatBool([TyphoonStringUtils isNotEmpty:@"1234"], equalToBool(YES));
    assertThatBool([TyphoonStringUtils isNotEmpty:@" \t\n"], equalToBool(NO));
}

- (void)test_isEmailAddress
{
    assertThatBool([TyphoonStringUtils isEmailAddress:@"asdf"], equalToBool(NO));
    assertThatBool([TyphoonStringUtils isEmailAddress:@"asd@"], equalToBool(NO));
    assertThatBool([TyphoonStringUtils isEmailAddress:@"asdf@foobar.com"], equalToBool(YES));
}


@end