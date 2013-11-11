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
#import <Typhoon/TyphoonTypeConverter.h>
#import <Typhoon/TyphoonTypeConverterRegistry.h>
#import <Typhoon/NSObject+TyphoonIntrospectionUtils.h>
#import <UIKit/UIKit.h>

@interface TyphoonUIColorConverterTests : SenTestCase

@property(nonatomic, strong, readonly) UIColor* color;

@end

@implementation TyphoonUIColorConverterTests

- (void)test_converts_string_to_UIColor
{
    TyphoonTypeDescriptor* descriptor = [self typeForPropertyWithName:@"color"];
    id <TyphoonTypeConverter> converter = [[TyphoonTypeConverterRegistry shared] converterFor:descriptor];
    NSString* converted = [converter convert:@"#ffffff"];
    assertThat(converted, notNilValue());
}

@end