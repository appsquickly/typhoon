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
#import "TyphoonInjectedProperty.h"
#import "TyphoonComponentInjectedByValue.h"

@interface TyphoonPropertyInjectedByValue : NSObject <TyphoonInjectedProperty, TyphoonComponentInjectedByValue>

@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, readonly) TyphoonPropertyInjectionType type;


- (id)initWithName:(NSString*)name value:(NSString*)value;


@end