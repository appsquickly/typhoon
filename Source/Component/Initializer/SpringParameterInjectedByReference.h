////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "SpringInjectedParameter.h"


@interface SpringParameterInjectedByReference : NSObject <SpringInjectedParameter>

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, readonly) SpringParameterInjectionType type;
@property (nonatomic, strong, readonly) NSString* reference;

- (id)initWithParameterIndex:(NSUInteger)parameterIndex reference:(NSString*)reference;


@end