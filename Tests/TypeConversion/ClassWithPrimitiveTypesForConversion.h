////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2014 ibipit
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of ibipit
//  Use is subject to license terms.
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