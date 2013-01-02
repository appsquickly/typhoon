////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "SpringInjectedProperty.h"


@interface SpringPropertyInjectedByReference : NSObject <SpringInjectedProperty>

@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, readonly) SpringPropertyInjectionType type;
@property (nonatomic, strong, readonly) NSString* reference;

- (id)initWithName:(NSString*)name reference:(NSString*)reference;

- (NSString*)description;

@end