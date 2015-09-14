////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@interface TyphoonViewHelpers : NSObject

+ (id)viewFromDefinition:(NSString *)definitionKey originalView:(UIView *)original;
+ (void)transferPropertiesFromView:(UIView *)src toView:(UIView *)dst;

@end
