//
//  TyphoonLoadedViewHelpers.h
//  Typhoon
//
//  Created by Herman Saprykin on 26/08/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TyphoonViewHelpers : NSObject

+ (id)viewFromDefinition:(NSString *)definitionKey originalView:(UIView *)original;
+ (void)transferPropertiesFromView:(UIView *)src toView:(UIView *)dst;

@end
