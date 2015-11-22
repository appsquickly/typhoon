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

#import "TyphoonViewControllerFactory.h"

#import "TyphoonStoryboardDefinitionContext.h"
#import "TyphoonComponentFactory+Storyboard.h"
#import "TyphoonComponentFactory+TyphoonDefinitionRegisterer.h"

//-------------------------------------------------------------------------------------------
#pragma mark - UIViewController + TyphoonDefinitionKey

@interface UIViewController (TyphoonStoryboardIntegration)

@property(nonatomic, strong) NSString *typhoonKey;

- (void)setViewDidLoadNotificationBlock:(void(^)(void))viewDidLoadBlock;

+ (void)swizzleViewDidLoadMethod;

@end

@implementation UIViewController (TyphoonStoryboardIntegration)

static const char *kTyphoonKey;
static const char *kTyphoonViewDidLoadBlock;

- (void)setTyphoonKey:(NSString *)typhoonKey
{
    objc_setAssociatedObject(self, &kTyphoonKey, typhoonKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)typhoonKey
{
    return objc_getAssociatedObject(self, &kTyphoonKey);
}

- (void)setViewDidLoadNotificationBlock:(void(^)(void))viewDidLoadBlock
{
    objc_setAssociatedObject(self, &kTyphoonViewDidLoadBlock, viewDidLoadBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void)swizzleViewDidLoadMethod
{
    SEL sel = @selector(viewDidLoad);
    Method method = class_getInstanceMethod([UIViewController class], sel);
    
    void(*originalImp)(id, SEL) = (void (*)(id, SEL)) method_getImplementation(method);
    
    IMP adjustedImp = imp_implementationWithBlock(^void(id instance) {
        
        void(^didLoadBlock)(void) = objc_getAssociatedObject(instance, &kTyphoonViewDidLoadBlock);
        if (didLoadBlock) {
            didLoadBlock();
            objc_setAssociatedObject(instance, &kTyphoonViewDidLoadBlock, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
        
        originalImp(instance, sel);
    });
    
    method_setImplementation(method, adjustedImp);
}

@end

//-------------------------------------------------------------------------------------------
#pragma mark - UIView + TyphoonDefinitionKey

@interface UIView (TyphoonDefinitionKey)

@property(nonatomic, strong) NSString *typhoonKey;

@end

@implementation UIView (TyphoonDefinitionKey)

static const char *kTyphoonKey;

- (void)setTyphoonKey:(NSString *)typhoonKey
{
    objc_setAssociatedObject(self, &kTyphoonKey, typhoonKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)typhoonKey
{
    return objc_getAssociatedObject(self, &kTyphoonKey);
}

@end

@interface TyphoonViewControllerFactory ()

@property (strong, nonatomic) TyphoonComponentFactory *factory;

@end

@implementation TyphoonViewControllerFactory

- (instancetype)initWithFactory:(TyphoonComponentFactory *)factory
{
    self = [super init];
    if (self) {
        _factory = factory;
    }
    return self;
}

- (UIViewController *)viewControllerWithStoryboardContext:(TyphoonStoryboardDefinitionContext *)context
{
    NSMutableDictionary *storyboardPool = [self.factory storyboardPool];
    
    UIStoryboard *storyboard = storyboardPool[context.storyboardName];
    if (!storyboard) {
        storyboard = [UIStoryboard storyboardWithName:context.storyboardName
                                               bundle:[NSBundle bundleForClass:[self class]]];
        @synchronized(self) {
            storyboardPool[context.storyboardName] = storyboard;
        }
    }
    
    UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:context.storyboardId];
    UIViewController *result = [self configureOrObtainFromPoolViewControllerForInstance:viewController];
    
    return result;
}

- (UIViewController *)viewControllerWithPrototype:(UIViewController *)prototype
{
    UIViewController *result = [self configureOrObtainFromPoolViewControllerForInstance:prototype];
    return result;
}

- (id)configureOrObtainFromPoolViewControllerForInstance:(UIViewController *)instance
{
    UIViewController *cachedInstance;
    
    cachedInstance = [self.factory scopeCachedViewControllerForInstance:instance typhoonKey:instance.typhoonKey];
    
    if (cachedInstance) {
        return cachedInstance;
    }
    
    [self injectPropertiesForViewController:instance];
    return instance;
}

- (void)injectPropertiesForViewController:(UIViewController *)viewController
{
    if (viewController.typhoonKey.length > 0) {
        [self.factory inject:viewController withSelector:NSSelectorFromString(viewController.typhoonKey)];
    }
    else {
        [self.factory inject:viewController];
    }
    
    for (UIViewController *controller in viewController.childViewControllers) {
        [self injectPropertiesForViewController:controller];
    }
    
    __weak __typeof (viewController) weakViewController = viewController;
    [viewController setViewDidLoadNotificationBlock:^{
        [self injectPropertiesInView:weakViewController.view];
    }];
}

- (void)injectPropertiesInView:(UIView *)view
{
    if (view.typhoonKey.length > 0) {
        [self.factory inject:view withSelector:NSSelectorFromString(view.typhoonKey)];
    }
    
    if ([view.subviews count] == 0) {
        return;
    }
    
    for (UIView *subview in view.subviews) {
        [self injectPropertiesInView:subview];
    }
}

@end
