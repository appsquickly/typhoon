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
#import "SpringInjectedProperty.h"


@interface SpringPropertyInjectedByType : NSObject <SpringInjectedProperty>

@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, readonly) SpringPropertyInjectionType type;

- (id)initWithName:(NSString*)name;


@end