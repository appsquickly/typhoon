////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIView+TyphoonOutletTransfer.h"
#import "UIResponder+TyphoonOutletTransfer.h"
#import <objc/runtime.h>

@implementation UIView (TyphoonOutletTransfer)

- (void)setTyphoonNeedTransferOutlets:(BOOL)typhoonNeedTransferOutlets
{
    objc_setAssociatedObject(self, @selector(typhoonNeedTransferOutlets), @(typhoonNeedTransferOutlets), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)typhoonNeedTransferOutlets
{
    return [objc_getAssociatedObject(self, @selector(typhoonNeedTransferOutlets)) boolValue];
}


// Swizzle awakeFromNib
// After the [super awakeFromNib] all the outlets on view will be set
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(awakeFromNib);
        SEL swizzledSelector = @selector(typhoon_awakeFromNib);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
        
    });
}

- (void)typhoon_awakeFromNib
{
    [self typhoon_awakeFromNib];
    // When view have superview transfer outlets if needed
    if (self.typhoonNeedTransferOutlets) {
        // recursive search for root view (superview without superview)
        UIView *rootView = [self findRootView:self];
        
        // Change UIViewController outlets properties
        UIResponder *nextRexponder = [rootView nextResponder];
        if ([nextRexponder isKindOfClass:[UIViewController class]]) {
            [nextRexponder transferConstraintsFromView:self];
        }
        
        // recursive check and change super outlets properties
        [self transferOutlets:rootView
                 transferView:self];
        // Mark that the transportation of finished
        self.typhoonNeedTransferOutlets = NO;
    }    
}

- (void)transferOutlets:(UIView *)view
           transferView:(UIView *)transferView
{
    [view transferConstraintsFromView:transferView];
    
    // Optimization. The outlet from view to the subview of TyphoonLoadedView is invalid.
    if (view == transferView) {
        return;
    }
    
    for (UIView *subview in view.subviews) {
        [subview transferOutlets:subview
                    transferView:transferView];
    }
}

- (UIView *)findRootView:(UIView *)view
{
    NSArray *expulsionViewClasses = [self expulsionViewClasses];
    // Optimization. The outlet from view to the UICollectionViewCell is invalid.
    // Outlets cannot be connected to repeating content.
    for (Class expulsionClass in expulsionViewClasses) {
        if ([view isKindOfClass:expulsionClass]) {
            return view;
        }
    }
    
    UIResponder *nextRexponder = [view nextResponder];
    if ([nextRexponder isKindOfClass:[UIViewController class]]) {
        return view;
    }

    if (view.superview) {
        return [view.superview findRootView:view.superview];
    }
    return view;
}

- (NSArray *)expulsionViewClasses
{
    return @[[UITableViewCell class],
             [UICollectionViewCell class]];
}

@end
