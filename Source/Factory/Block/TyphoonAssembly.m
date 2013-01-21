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
#import "TyphoonDefinition.h"


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
    if ([name hasSuffix:TYPHOON_BEFORE_ADVICE_SUFFIX])
    {
        IMP imp = imp_implementationWithBlock((__bridge id) objc_unretainedPointer(^(id me, BOOL selected)
        {
            NSString* key = [name stringByReplacingOccurrencesOfString:TYPHOON_BEFORE_ADVICE_SUFFIX withString:@""];

            NSLog(@"Looking up cached value for: %@", key);
            id cached = [[me cachedSelectors] objectForKey:key];

            if (cached == nil)
            {
                NSLog(@"Cache empty, populating. . . ");
                NSError* error;
                [[self class] typhoon_swizzleMethod:sel withMethod:NSSelectorFromString(key) error:&error];
                if (error)
                {
                    [NSException raise:NSInternalInconsistencyException format:[error description]];
                }
                cached = objc_msgSend(me, sel);
                if (cached && [cached isKindOfClass:[TyphoonDefinition class]])
                {
                    TyphoonDefinition* definition = (TyphoonDefinition*) cached;
                    if ([definition.key length] == 0)
                    {
                        definition.key = key;
                    }
                    [[me cachedSelectors] setObject:definition forKey:key];
                }
                [[self class] typhoon_swizzleMethod:NSSelectorFromString(key) withMethod:sel error:&error];
                if (error)
                {
                    [NSException raise:NSInternalInconsistencyException format:[error description]];
                }
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

/* ============================================================ Utility Methods ========================================================= */
- (void)dealloc
{
    NSLog(@"$$$$$$ %@ in dealloc!", [self class]);
}

/* ============================================================ Private Methods ========================================================= */
- (NSMutableDictionary*)cachedSelectors
{
    return _cachedDefinitions;
}


@end