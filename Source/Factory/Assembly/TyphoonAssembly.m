////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2013 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <objc/runtime.h>
#import <objc/message.h>
#import "TyphoonAssembly.h"
#import "TyphoonJRSwizzle.h"
#import "TyphoonComponentDefinition.h"
#import "Knight.h"
#import "TyphoonComponentDefinition+BlockBuilders.h"
#import "TyphoonComponentInitializer.h"
#import "CampaignQuest.h"


@implementation TyphoonAssembly

/* =========================================================== Class Methods ============================================================ */
+ (TyphoonAssembly*)assembly
{
    return [[[self class] alloc] init];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([TyphoonAssembly selectorReserved:sel])
    {
        return [super resolveInstanceMethod:sel];
    }
    NSString* name = NSStringFromSelector(sel);
    if ([name hasSuffix:@"__typhoonBeforeAdvice"])
    {
        IMP imp = imp_implementationWithBlock((__bridge id) objc_unretainedPointer(^(id me, BOOL selected)
        {
            NSLog(@"Starting. . . ");
            NSString* originalSelectorAsString =
                    [NSStringFromSelector(sel) stringByReplacingOccurrencesOfString:@"__typhoonBeforeAdvice" withString:@""];
            NSMutableDictionary* cache = [me cachedSelectors];

            NSString* key = [NSStringFromSelector(sel) stringByReplacingOccurrencesOfString:@"__typhoonCachedValue" withString:@""];
            NSLog(@"Looking up cached value for: %@", key);
            id cached = [cache objectForKey:key];
            NSLog(@"$$$$$$$$ Here it is: %@", cached);

            if (cached == nil)
            {
                NSLog(@"Populating cache: %@", name);
                NSError* error;
                [[self class] typhoon_swizzleMethod:sel withMethod:NSSelectorFromString(originalSelectorAsString) error:&error];
                if (error)
                {
                    NSLog(@"Error: %@", error);
                }
                cached = objc_msgSend(me, sel);
                if (cached)
                {
                    [cache setObject:cached forKey:key];
                }
                NSLog(@"Cached now: %@", cached);
                [[self class] typhoon_swizzleMethod:sel withMethod:NSSelectorFromString(originalSelectorAsString) error:&error];
                if (error)
                {
                    NSLog(@"Error: %@", error);
                }
            }
            else
            {
                NSLog(@"Returning cached");
            }

            return cached;

        }));
        class_addMethod(self, sel, imp, "@");
        return YES;
    }
    return NO;
}

+ (BOOL)selectorReserved:(SEL)selector
{
    return selector == @selector(init) || selector == @selector(cachedSelectors) || selector == NSSelectorFromString(@".cxx_destruct");
}

/* ============================================================ Initializers ============================================================ */
- (id)init
{
    self = [super init];
    if (self)
    {
        _cachedDefinitions = [[NSMutableDictionary alloc] init];
    }
    return self;
}


/* ============================================================ Private Methods ========================================================= */
- (NSMutableDictionary*)cachedSelectors
{
    return _cachedDefinitions;
}



@end