////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>


@interface ClassWithPrimitiveTypesForConversion : NSObject

@property(nonatomic) BOOL boolProperty;
@property(nonatomic) int intProperty;
@property(nonatomic) NSUInteger nsuIntegerProperty;
@property(nonatomic) Class classProperty;
@property(nonatomic) double doubleProperty;
@property(nonatomic) long longProperty;
@property(nonatomic) SEL selectorProperty;
@property(nonatomic) char *cStringProperty;
@property(nonatomic) unsigned char unsignedCharProperty;
@property(nonatomic) NSUInteger unsignedLongLongProperty;
@property(nonatomic) unsigned int unsignedIntProperty;

@end