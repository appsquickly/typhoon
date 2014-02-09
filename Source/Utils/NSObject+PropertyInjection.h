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

@class TyphoonTypeDescriptor;

@interface NSObject (PropertyInjection)

- (void)injectValue:(id)value forPropertyName:(NSString *)propertyName withType:(TyphoonTypeDescriptor *)type;

@end
