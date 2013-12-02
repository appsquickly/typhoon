////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <objc/runtime.h>
#import <objc/message.h>
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "TyphoonDefinition.h"
#import "TyphoonJRSwizzle.h"
#import "OCLogTemplate.h"
#import "TyphoonAssemblySelectorAdviser.h"
#import "TyphoonAssemblyAdviser.h"

@interface TyphoonAssembly (BlockFactoryFriend)

- (NSMutableDictionary*)cachedDefinitionsForMethodName;

@end

@implementation TyphoonBlockComponentFactory

/* ====================================================================================================================================== */
#pragma mark - Class Methods
+ (instancetype)factoryWithAssembly:(TyphoonAssembly*)assembly
{
    return [[self alloc] initWithAssemblies:@[assembly]];
}

+ (instancetype)factoryWithAssemblies:(NSArray*)assemblies
{
    return [[self alloc] initWithAssemblies:assemblies];
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (instancetype)initWithAssembly:(TyphoonAssembly*)assembly
{
    return [self initWithAssemblies:@[assembly]];
}

- (instancetype)initWithAssemblies:(NSArray*)assemblies
{
    self = [super init];
    if (self)
    {
        for (TyphoonAssembly* assembly in assemblies)
        {
            LogTrace(@"Building assembly: %@", NSStringFromClass([assembly class]));

            // raise exception if not an Assembly
            if (![assembly isKindOfClass:[TyphoonAssembly class]]) // not an assembly
            {
                // raise a 'not an assembly exception'
                [NSException raise:NSInvalidArgumentException format:@"Class '%@' is not a sub-class of %@",
                                                                     NSStringFromClass([assembly class]),
                                                                     NSStringFromClass([TyphoonAssembly class])];
            }

            // why do we have to do this?
            // it:
            /*
                Swizzles all definition methods, so that a call to the assembly builds and caches a definition, which is then returned.
                The complexity is with fully constructing the definition, complete with circular dependencies.
             */

            // this should be done when an assembly is about to be used, and is done being constructed.
            // assemblies are static, so why not do this in [Assembly load]?
            // this works okay, but why not tell the assembly that it is about to be used and have the assmebly deal with advising?
            // would need to be called whenever any subclass was loaded, too - which means subclass loads need to call super? correct.
            [TyphoonAssemblyAdviser adviseMethods:assembly];

            // register all assembly definitions
            NSArray* definitions = [self definitionsByPopulatingCache:assembly];
            for (TyphoonDefinition* definition in definitions)
            {
                [self register:definition];
            }
        }
    }
    return self;
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (void)forwardInvocation:(NSInvocation*)invocation
{
    NSString* componentKey = NSStringFromSelector([invocation selector]);
    LogTrace(@"Component key: %@", componentKey);

    [invocation setSelector:@selector(componentForKey:)];
    [invocation setArgument:&componentKey atIndex:2];
    [invocation invoke];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)aSelector
{
    if ([self respondsToSelector:aSelector])
    {
        return [[self class] instanceMethodSignatureForSelector:aSelector];
    }
    else
    {
        return [[self class] instanceMethodSignatureForSelector:@selector(componentForKey:)];
    }
}


/* ====================================================================================================================================== */
#pragma mark - Private Methods

// replace with:
//
// [assembly populateCache];
// [assembly definitions]; // can we do this without populating cache? make the cache population a side effect?
- (NSArray*)definitionsByPopulatingCache:(TyphoonAssembly*)assembly
{
    @synchronized (self)
    {
        [self populateCacheOnAssembly:assembly];
        return [[assembly cachedDefinitionsForMethodName] allValues];
    }
}

// replace with [aseembly populateCache];
- (void)populateCacheOnAssembly:(TyphoonAssembly*)assembly
{
    // by calling all definition selectors
    // how do we know that this populates the definition cache?
        // where is the new impl?
        // in the assembly.
    NSSet* definitionSelectors = [TyphoonAssemblyAdviser obtainDefinitionSelectors:assembly]; // the Assembly should know what its own definition selectors are.

    [definitionSelectors enumerateObjectsUsingBlock:^(id obj, BOOL* stop)
    {
        SEL selector = (SEL) [obj pointerValue];
        objc_msgSend(assembly, selector);
    }];
}

@end