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
#import "TyphoonComponentFactory.h"

//static NSMutableArray* resolveStack;
static NSMutableDictionary *resolveStackForKey;

@implementation TyphoonAssembly


/* =========================================================== Class Methods ============================================================ */
+ (TyphoonAssembly*)assembly
{
    return [[[self class] alloc] init];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([self shouldProvideDynamicImplementationFor:sel]) {
        [self provideDynamicImplementationForDefinitionMethodByDoingSomethingAroundIt:sel];
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)shouldProvideDynamicImplementationFor:(SEL)sel;
{
    NSString* name = NSStringFromSelector(sel);
    return (![TyphoonAssembly selectorReserved:sel] && [name hasSuffix:TYPHOON_BEFORE_ADVICE_SUFFIX]); // a name will always have this suffix after a TyphoonBlockComponentFactory has been initialized with us as the assembly. Make this clearer. All user facing calls will go through the dynamic implementation machinery.
}

+ (void)provideDynamicImplementationForDefinitionMethodByDoingSomethingAroundIt:(SEL)sel;
{
    NSString* name = NSStringFromSelector(sel);
    IMP imp = [self implementationToWrapDefinitionReturningMethodAndDoSomethingAroundWithSEL:sel name:name];
    class_addMethod(self, sel, imp, "@");
}

+ (void)setKey:(NSString *)key onDefinitionIfExistingKeyEmpty:(TyphoonDefinition *)definition
{
    if ([definition.key length] == 0)
    {
        definition.key = key;
    }
}

+ (IMP)implementationToWrapDefinitionReturningMethodAndDoSomethingAroundWithSEL:(SEL)selWithAdvicePrefix name:(NSString *)name
{
    return imp_implementationWithBlock((__bridge id) objc_unretainedPointer(^(id me)
       {
           NSString* key = [name stringByReplacingOccurrencesOfString:TYPHOON_BEFORE_ADVICE_SUFFIX withString:@""];
            NSMutableArray *resolveStack = [resolveStackForKey objectForKey:key];
            if (!resolveStack) {
                resolveStack = [[NSMutableArray alloc] init];
                [resolveStackForKey setObject:resolveStack forKey:key];
            }

           TyphoonDefinition* cached = [[me cachedDefinitionsForMethodName] objectForKey:key];
           if (cached == nil)
            {
                NSLog(@"%@ not cached.", key);
                
                [resolveStack addObject:key];
                NSLog(@"Resolve stack: %@ for key: %@", resolveStack, key);
                
                if ([resolveStack count] > 2)
                {
                    NSString* bottom = [resolveStack objectAtIndex:0];
                    NSString* top = [resolveStack objectAtIndex:[resolveStack count] - 1];
                    if ([top isEqualToString:bottom])
                    {
                        NSLog(@"CIRCULAR DEPNEDENCY DETECTEED! TERMINATIN IT WITH SOME DUMMY DEFINITION!");
                        return [[TyphoonDefinition alloc] initWithClass:[NSString class] key:key];
//                        [NSException raise:NSInternalInconsistencyException format:@"Circular dependency detected."];
                    }
                }

//                [[self class] typhoon_swizzleMethod:sel withMethod:NSSelectorFromString(key) error:nil];
//                SEL normalSEL = NSSelectorFromString(key);
                cached = objc_msgSend(me, sel); // will go to normal b/c of swizzling. 
                if (cached && [cached isKindOfClass:[TyphoonDefinition class]])
                {
                    TyphoonDefinition* definition = (TyphoonDefinition*) cached;
                    if ([definition.key length] == 0)
                    {
                        definition.key = key;
                    }
                    [[me cachedSelectors] setObject:definition forKey:key];
                }
//                [[self class] typhoon_swizzleMethod:NSSelectorFromString(key) withMethod:sel error:nil];
                NSLog(@"Did finish satisfying: %@", key);
            }else{
                NSLog(@"returning cached key %@.", key);
            }
            if (resolveStack.count) {
                NSLog(@"Will clear resolve stack: %@ for key: %@", resolveStack, key);
            }
            [resolveStack removeAllObjects]; 
            #warning BUG!
            
            
            return cached;
       }));
}

+ (TyphoonAssembly*)defaultAssembly
{
    return (TyphoonAssembly*) [TyphoonComponentFactory defaultFactory];
}


+ (BOOL)selectorReserved:(SEL)selector
{
    return selector == @selector(init) || selector == @selector(cachedDefinitionsForMethodName) || selector == NSSelectorFromString(@".cxx_destruct") ||
            selector == @selector(defaultAssembly);
}

+ (void)load
{
    [super load];
//    resolveStack = [[NSMutableArray alloc] init];
    resolveStackForKey = [[NSMutableDictionary alloc] init];
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
- (NSMutableDictionary*)cachedDefinitionsForMethodName
{
    return _cachedDefinitions;
}


@end