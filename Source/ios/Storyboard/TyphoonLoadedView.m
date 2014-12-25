////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonLoadedView.h"
#import "TyphoonStoryboard.h"
#import <objc/runtime.h>

@implementation TyphoonLoadedView

- (NSString *)typhoonKey
{
    return [self restorationIdentifier];
}

- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    id replacement = [[self class] viewFromDefinition:[self typhoonKey] originalView:self];
    if (replacement != self) {
        /**
         * Coupling view loaded from Xib with replacement loaded from Typhoon
         * to retain view loaded from Xib, to avoid UIKit bug that cause crash.
         * Reason: Sometimes UIKit sends 'isDescendantOfView:' message during AutoLayout solving
         * to initially loaded view after it's dealloc. It's strange because this view hasn't superview.
         * */
        objc_setAssociatedObject(replacement, "TyphoonXibPrototype", self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return replacement;
}

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

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    [[UIColor colorWithWhite:0.93 alpha:1] setFill];

    CGContextFillRect(context, self.bounds);

    UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithWhite:0.78 alpha:1];

    UIFont *baseFont = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:33];
    UIFont *subtitleFont = [baseFont fontWithSize:24];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Typhoon Definition\n" attributes:@{NSFontAttributeName : baseFont}];
    if ([self typhoonKey]) {
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:[self typhoonKey] attributes:@{
                NSFontAttributeName : subtitleFont
        }]];
    } else {
        [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"key is missing" attributes:@{
                NSFontAttributeName : subtitleFont,
                NSForegroundColorAttributeName : [UIColor colorWithRed:0.74f green:0.18f blue:0.18f alpha:1.0f]
        }]];
    }

    label.attributedText = string;

    [label drawRect:self.bounds];
}


@end

