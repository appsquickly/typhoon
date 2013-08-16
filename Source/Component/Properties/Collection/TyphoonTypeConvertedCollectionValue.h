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

#import <Foundation/Foundation.h>
#import "TyphoonCollectionValue.h"


@interface TyphoonTypeConvertedCollectionValue : NSObject<TyphoonCollectionValue>

@property (nonatomic, strong, readonly) NSString* textValue;
@property (nonatomic, strong, readonly) Class requiredType;

- (id)initWithTextValue:(NSString*)textValue requiredType:(Class)requiredType;


@end