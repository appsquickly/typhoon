//
// Created by Aleksey Garbarev on 11.12.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import "UIView+TyphoonStoryboard.h"
#import "TyphoonStoryboard.h"
#import <objc/runtime.h>

@implementation UIView (TyphoonStoryboard)

static NSMutableSet *loadingDefinitions;
static NSArray *propertiesToTransfer;
static const char *kTyphoonKey;

- (void)setTyphoonKey:(NSString *)typhoonKey
{
    objc_setAssociatedObject(self, &kTyphoonKey, typhoonKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)typhoonKey
{
    return objc_getAssociatedObject(self, &kTyphoonKey);
}

IMP originalAwakeUsingCoder;

+ (void)load
{
    IMP customImp = class_getMethodImplementation([UIView class], @selector(typhoon_awakeAfterUsingCoder:));
    Method originalMethod = class_getInstanceMethod([UIView class], @selector(awakeAfterUsingCoder:));

    originalAwakeUsingCoder = method_setImplementation(originalMethod, customImp);
}

+ (void)initialize
{
    loadingDefinitions = [NSMutableSet new];

    propertiesToTransfer = @[@"backgroundColor", @"frame", @"opaque", @"clipsToBounds", @"autoresizesSubviews",
            @"autoresizingMask", @"hidden", @"clearsContextBeforeDrawing", @"tintColor", @"alpha",
            @"exclusiveTouch", @"userInteractionEnabled", @"contentMode"];
    [super initialize];
}

- (id)typhoon_awakeAfterUsingCoder:(NSCoder *)aDecoder
{
    id result = nil;

    if ([self isKindOfClass:[UIView class]]) {

        if (self.typhoonKey.length > 0 && ![[self class] isLoadingXib:self.typhoonKey]) {
            result = [[self class] viewFromDefinition:self.typhoonKey originalView:self];
            CFRelease((__bridge const void*)self);
            CFRetain((__bridge const void*)result);
        }
    }

    if (!result) {
        result = originalAwakeUsingCoder(self, @selector(awakeAfterUsingCoder:), aDecoder);
    }

    return result;
}

+ (BOOL)isLoadingXib:(NSString *)name
{
    return [loadingDefinitions containsObject:name];
}

+ (TyphoonComponentFactory *)currentFactory
{
    TyphoonComponentFactory *factory = [TyphoonComponentFactory currentFactory];

    if (!factory) {
        factory = [[TyphoonStoryboard currentStoryboard] factory];
    }

    return factory;
}

+ (id)viewFromDefinition:(NSString *)definitionKey originalView:(UIView *)original
{
    [loadingDefinitions addObject:definitionKey];
    if ([[original subviews] count] > 0) {
        NSLog(@"Warning: placeholder view contains (%d) subviews. They will be replaced by typhoon definition '%@'", [[original subviews] count], definitionKey);
    }
    TyphoonComponentFactory *currentFactory = [self currentFactory];
    if (!currentFactory) {
        NSLog(@"Warning: typhoonKey '%@' is set for view %@ but can't find Typhoon factory from context. Make sure that viewController contained view loaded via Typhono.", definitionKey, original);
    }
    id result = [currentFactory componentForKey:definitionKey];
    if (![result isKindOfClass:[UIView class]]) {
        NSLog(@"Error: definition for key '%@' is not kind of UIView (it's %@) but specified as replacement for %@", definitionKey, result, original);
        result = nil;
    }
    [loadingDefinitions removeObject:definitionKey];
    [self transferPropertiesFromView:original toView:result];
    return result;
}

+ (void)transferPropertiesFromView:(UIView *)src toView:(UIView *)dst
{
    //Transferring autolayout
    BOOL autoLayoutSupported = NSClassFromString(@"NSLayoutConstraint") != nil;
    if (autoLayoutSupported) {
        dst.translatesAutoresizingMaskIntoConstraints = NO;

        for (NSLayoutConstraint *constraint in src.constraints) {
            BOOL replaceFirstItem = [constraint firstItem] == src;
            BOOL replaceSecondItem = [constraint secondItem] == src;
            id firstItem = replaceFirstItem ? dst : constraint.firstItem;
            id secondItem = replaceSecondItem ? dst : constraint.secondItem;
            NSLayoutConstraint *copy = [NSLayoutConstraint constraintWithItem:firstItem attribute:constraint.firstAttribute relatedBy:constraint.relation toItem:secondItem attribute:constraint.secondAttribute multiplier:constraint.multiplier constant:constraint.constant];
            [dst addConstraint:copy];
        }
    }

    //Transferring properties
    for (NSString *name in propertiesToTransfer) {
        id value = [src valueForKey:name];
        if ([dst validateValue:&value forKey:name error:nil]) {
            [dst setValue:value forKey:name];
        }
    }
}

@end