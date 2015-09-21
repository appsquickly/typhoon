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

#import "TyphoonStoryboardResolver.h"
#import "TyphoonStartup.h"
#import "TyphoonStoryboard.h"
#import "TyphoonStoryboardProvider.h"

#import <objc/runtime.h>

static TyphoonComponentFactory *componentFactory;

@implementation TyphoonStoryboardResolver

+ (void)load
{
    NSBundle *bundle = [NSBundle mainBundle];
    TyphoonStoryboardProvider *provider = [TyphoonStoryboardProvider new];
    NSArray *resolvingStoryboardNames = [provider collectStoryboardsFromBundle:bundle];
    NSString *initialStoryboardName = [provider initialStoryboardNameInBundle:bundle];
    
    if (resolvingStoryboardNames.count > 0) {
        [self swizzleUIStoryboardWithNames:resolvingStoryboardNames
                     initialStoryboardName:initialStoryboardName];
    }
}

+ (void)swizzleUIStoryboardWithNames:(NSArray *)storyboardNames
               initialStoryboardName:(NSString *)initialName
{
    SEL sel = @selector(storyboardWithName:bundle:);
    Method method = class_getClassMethod([UIStoryboard class], sel);
    
    id(*originalImp)(id, SEL, id, id) = (id (*)(id, SEL, id, id)) method_getImplementation(method);
    
    IMP adjustedImp = imp_implementationWithBlock(^id(id instance, NSString *name, NSBundle *bundle) {
        BOOL isInitialStoryboard = [name isEqualToString:initialName];
        if (isInitialStoryboard) {
            [self retainComponentFactory];
        }
        
        if ([instance class] == [UIStoryboard class] && componentFactory && [storyboardNames containsObject:name]) {
            return [TyphoonStoryboard storyboardWithName:name factory:componentFactory bundle:bundle];
        } else {
            return originalImp(instance, sel, name, bundle);
        }
    });
    
    method_setImplementation(method, adjustedImp);
}

+ (void)retainComponentFactory
{
    [TyphoonStartup requireInitialFactory];
    componentFactory = [TyphoonStartup initialFactory];
    [TyphoonStartup releaseInitialFactory];
}

@end
