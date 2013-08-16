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
#import "TyphoonInjectedProperty.h"

/**
* Represents a property injected by referencing another definition in the container.
*/
@interface TyphoonPropertyInjectedByReference : NSObject <TyphoonInjectedProperty>

@property (nonatomic, strong, readonly) NSString* name;
@property (nonatomic, strong, readonly) NSString* reference;

- (id)initWithName:(NSString*)name reference:(NSString*)reference;


@end