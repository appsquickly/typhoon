////////////////////////////////////////////////////////////////////////////////
//
//  INFRAXIS
//  Copyright 2013 Infraxis
//  All Rights Reserved.
//
//  NOTICE: Infraxis permits you to use, modify, and distribute this file
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