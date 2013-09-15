////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonStringUtils.h"

@interface TyphoonStringUtilsTests : SenTestCase


@end


@implementation TyphoonStringUtilsTests

- (void)test_should_match_alpha_chars
{
    assertThatBool([TyphoonStringUtils isAlpha:@"1234"], equalToBool(NO));
    assertThatBool([TyphoonStringUtils isAlpha:@"abc1234"], equalToBool(NO));

    assertThatBool([TyphoonStringUtils isAlpha:@"abc"], equalToBool(YES));
}

@end