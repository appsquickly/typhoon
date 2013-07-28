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

static NSMutableArray* resolveStack;

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
           TyphoonDefinition* cached = [[me cachedDefinitionsForMethodName] objectForKey:key];
           if (cached == nil)
           {
               [resolveStack addObject:key];
               if ([resolveStack count] > 2)
               {
                   NSString* bottom = [resolveStack objectAtIndex:0];
                   NSString* top = [resolveStack objectAtIndex:[resolveStack count] - 1];
                   if ([top isEqualToString:bottom])
                   {
                       NSLog(@"Resolve stack: %@", resolveStack);
                                              return [[TyphoonDefinition alloc] initWithClass:[NSString class] key:key]; // safe to return nonsense here because the TyphoonBlockComponentFactory doesn't use the return value, and instead cares about cached selectors.
                       // this terminates the circular dependecy. the definition closest to the top of the resolve stack is the one used. this will NOT be a nonsense definition.
                       
                       // this is never hit when a cached definition is available, which occurs for all calling user code AFTER initial construction.
                       //    [NSException raise:NSInternalInconsistencyException format:@"Circular dependency detected."];
                       //                       return nil; // will need to call this. 
                   }
               }
               
               SEL originalSEL = NSSelectorFromString(key);
               [[self class] typhoon_swizzleMethod:selWithAdvicePrefix withMethod:originalSEL error:nil]; // let there be an assembly method called 'objectDefinition', returning a TyphoonDefinition.
                                                                                                          // in the block below, this dynami9c swizzling will be turned off.
               
               
               // BELOW IS NOT TRUE!
                                                                                                      // in the block below, the implementation of 'objectDefinition' will be resolved dynamically as '#{TYPHOON_BEFORE_ADVICE_SUFFIX}objectDefinition'.
                                                                                                      // calling '#{TYPHOON_BEFORE_ADVICE_SUFFIX}objectDefinition' will be resolved as calling 'objectDefinition'
               
               
               
               cached = objc_msgSend(me, selWithAdvicePrefix); // normally would go to the original method. now is dynamic and reentrant. this explains:
               /**
                2013-07-28 10:18:27.024 otest[73021:303] Building assembly: CircularDependenciesAssembly
                2013-07-28 10:18:27.024 otest[73021:303] Just applied before advice prefix to all definition selectors on assembly <CircularDependenciesAssembly: 0x1756d50>.
                2013-07-28 10:18:27.025 otest[73021:303] Resolve stack: (
                classB,
                classB,
                classA,
                classA,
                classB
                )
                */
               
               if (cached && [cached isKindOfClass:[TyphoonDefinition class]]) // when can it NOT be a TyphoonDefinition? raise here if its not. will be nil when returning nil to not stick garbage in here, even temporarily.
               {
                   TyphoonDefinition* definition = (TyphoonDefinition*) cached;
                   [self setKey:key onDefinitionIfExistingKeyEmpty:definition];
                   [[me cachedDefinitionsForMethodName] setObject:definition forKey:key];
               }
               [[self class] typhoon_swizzleMethod:originalSEL withMethod:selWithAdvicePrefix error:nil];
               // restore original implementations - '#{TYPHOON_BEFORE_ADVICE_SUFFIX}objectDefinition' will be dynamically handled, and direct calls handled normally.
               
           }
           [resolveStack removeAllObjects]; // why outside the if (cached == nil)?
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
    resolveStack = [[NSMutableArray alloc] init];
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