//
// Created by Aleksey Garbarev on 06.06.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

#import "TyphoonInitialStoryboardResolver.h"
#import "TyphoonStartup.h"
#import "TyphoonStoryboard.h"
#import <objc/runtime.h>

@implementation TyphoonInitialStoryboardResolver

+ (void)load
{
    NSString *initialStoryboardName = [self initialStoryboardName];

    if (initialStoryboardName.length > 0) {
        [self swizzleUIStoryboardWithName:initialStoryboardName];
    }
}

+ (void)swizzleUIStoryboardWithName:(NSString *)storyboardName
{
    SEL sel = @selector(storyboardWithName:bundle:);
    Method method = class_getClassMethod([UIStoryboard class], sel);

    id(*originalImp)(id, SEL, id, id) = (id (*)(id, SEL, id, id)) method_getImplementation(method);

    IMP adjustedImp = imp_implementationWithBlock(^id(id instance, NSString *name, NSBundle *bundle) {

        id initialFactory = [TyphoonStartup initialFactory];

        if ([instance class] == [UIStoryboard class] && initialFactory && [name isEqualToString:storyboardName]) {
            return [TyphoonStoryboard storyboardWithName:name factory:initialFactory bundle:bundle];
        } else {
            return originalImp(instance, sel, name, bundle);
        }
    });

    method_setImplementation(method, adjustedImp);
}

+ (NSString *)initialStoryboardName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIMainStoryboardFile"];
}

@end