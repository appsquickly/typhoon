//
//  TyphoonLoadedViewHelpers.m
//  Typhoon
//
//  Created by Herman Saprykin on 26/08/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import "TyphoonViewHelpers.h"
#import "TyphoonStoryboard.h"

@implementation TyphoonViewHelpers

+ (id)viewFromDefinition:(NSString *)definitionKey originalView:(UIView *)original
{
    if ([[original subviews] count] > 0) {
        NSLog(@"Warning: placeholder view contains (%d) subviews. They will be replaced by typhoon definition '%@'", (int)[[original subviews] count], definitionKey);
    }
    TyphoonComponentFactory *currentFactory = [TyphoonComponentFactory factoryForResolvingFromXibs];
    if (!currentFactory) {
        [NSException raise:NSInternalInconsistencyException format:@"Can't find Typhoon factory to resolve definition from xib. Check [TyphoonComponentFactory setFactoryForResolvingFromXibs:] method."];
    }
    id result = [currentFactory componentForKey:definitionKey];
    if (![result isKindOfClass:[UIView class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Error: definition for key '%@' is not kind of UIView but %@", definitionKey, result];
    }
    [self transferPropertiesFromView:original toView:result];
    return result;
}

+ (void)transferPropertiesFromView:(UIView *)src toView:(UIView *)dst
{
    //Transferring autolayout
    dst.translatesAutoresizingMaskIntoConstraints = src.translatesAutoresizingMaskIntoConstraints;

    for (NSLayoutConstraint *constraint in src.constraints) {
        BOOL replaceFirstItem = [constraint firstItem] == src;
        BOOL replaceSecondItem = [constraint secondItem] == src;
        id firstItem = replaceFirstItem ? dst : constraint.firstItem;
        id secondItem = replaceSecondItem ? dst : constraint.secondItem;
        NSLayoutConstraint *copy = [NSLayoutConstraint constraintWithItem:firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:secondItem attribute:constraint.secondAttribute multiplier:constraint.multiplier constant:constraint.constant];
        [dst addConstraint:copy];
    }
    
    dst.frame = src.frame;
    dst.autoresizesSubviews = src.autoresizesSubviews;
    dst.autoresizingMask = src.autoresizingMask;
}

@end
