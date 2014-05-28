////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <XCTest/XCTest.h>
#import "TyphoonMiscUtils.h"


@interface TyphoonMiscUtilsTests : XCTestCase
@end


@implementation TyphoonMiscUtilsTests
{

}

- (void)testLessThanFour
{
    [self expectOrdinal:@"0th" forIndex:0];
    [self expectOrdinal:@"1st" forIndex:1];
    [self expectOrdinal:@"2nd" forIndex:2];
    [self expectOrdinal:@"3rd" forIndex:3];
}

- (void)testFourThroughTwenty_Th
{
    for (int i = 4; i <= 20; i++) {
        [self expectOrdinal:[NSString stringWithFormat:@"%ith", i] forIndex:i];
    }
}

- (void)testLastDigitLessThanFour
{
    [self expectOrdinal:@"20th" forIndex:20];
    [self expectOrdinal:@"21st" forIndex:21];
    [self expectOrdinal:@"22nd" forIndex:22];
    [self expectOrdinal:@"23rd" forIndex:23];
    [self expectOrdinal:@"24th" forIndex:24];
}

- (void)expectOrdinal:(NSString *)string forIndex:(int)index
{
    XCTAssertEqualObjects([TyphoonMiscUtils ordinalForIndex:index], string);
}

// 1st, 2nd, 3rd, 4th, 5th, 6th, 7th, etc
/*

Spatial/chronological	first	second	third	fourth	fifth	sixth	seventh	eighth	ninth	tenth	eleventh	twelfth
Precedence/effect	primary	secondary	tertiary	quaternary	quinary	senary	septenary	octonary	novenary	decenary	undecenary	duodecenary
Greek prefix	proto-	deutero-	trito-	tetarto-	pempto-	ecto-	ebdomo-	ogdoo-	enato-	decato-	endecato-	dodecato-
The spatial/chronological ordinal numbers corresponding to cardinals from 13 to 19 are the number followed by the suffix -th, as "sixteenth". For multiples of ten, the same principle applies, with terminal -y changed to -ieth, as "sixtieth". For other numbers, the elements of the cardinal number are used, with the last word replaced by the ordinal: 23 → "twenty-third"; 523 → "five hundred and twenty-third".
 */

@end