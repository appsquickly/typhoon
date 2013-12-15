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
#import "TyphoonAssembly.h"
#import "TyphoonDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonAssemblySelectorAdviser.h"
#import "OCLogTemplate.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonAssemblyAdviser.h"
#import "TyphoonAssemblyDefinitionBuilder.h"

static NSMutableArray* reservedSelectorsAsStrings;

@interface TyphoonAssembly()

@property (readwrite) NSSet *definitionSelectors;

@property (readonly) TyphoonAssemblyAdviser* adviser;

@end

@implementation TyphoonAssembly
{
    TyphoonAssemblyDefinitionBuilder* _definitionBuilder;
}


/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonAssembly*)assembly
{
    TyphoonAssembly* assembly = [[self alloc] init];
    [assembly resolveCollaboratingAssemblies];
    return assembly;
}

+ (instancetype)defaultAssembly
{
    return (TyphoonAssembly*)[TyphoonComponentFactory defaultFactory];
}

+ (void)load
{
    [self reserveSelectors];
}

+ (void)reserveSelectors;
{
    reservedSelectorsAsStrings = [[NSMutableArray alloc] init];

    [self markSelectorReserved:@selector(init)];
    [self markSelectorReserved:@selector(definitions)];
    [self markSelectorReserved:@selector(prepareForUse)];
    [self markSelectorReservedFromString:@".cxx_destruct"];
    [self markSelectorReserved:@selector(defaultAssembly)];
    [self markSelectorReserved:@selector(resolveCollaboratingAssemblies)];
}

+ (void)markSelectorReserved:(SEL)selector
{
    [self markSelectorReservedFromString:NSStringFromSelector(selector)];
}

+ (void)markSelectorReservedFromString:(NSString*)stringFromSelector
{
    [reservedSelectorsAsStrings addObject:stringFromSelector];
}

/* ====================================================================================================================================== */
#pragma mark - Instance Method Resolution
// handle definition method calls, mapping [self definitionA] to [self builtDefinitionForKey:@"definitionA"]
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([self shouldProvideDynamicImplementationFor:sel])
    {
        [self provideDynamicImplementationToConstructDefinitionForSEL:sel];
        return YES;
    }

    return [super resolveInstanceMethod:sel];
}

+ (BOOL)shouldProvideDynamicImplementationFor:(SEL)sel;
{
    return (![TyphoonAssembly selectorReservedOrPropertySetter:sel] && [TyphoonAssemblySelectorAdviser selectorIsAdvised:sel]);
}

+ (BOOL)selectorReservedOrPropertySetter:(SEL)selector
{
    NSString* selectorString = NSStringFromSelector(selector);
    if ([reservedSelectorsAsStrings containsObject:selectorString])
    {
        return YES;
    }
    else if ([self selectorIsPropertySetter:selector])
    {
        return YES;
    }

    return NO;
}

+ (BOOL)selectorIsPropertySetter:(SEL)selector
{
    NSString* selectorString = NSStringFromSelector(selector);
    return [selectorString hasPrefix:@"set"] && [selectorString hasSuffix:@":"];
}

+ (void)provideDynamicImplementationToConstructDefinitionForSEL:(SEL)sel;
{
    IMP imp = [self implementationToConstructDefinitionForSEL:sel];
    class_addMethod(self, sel, imp, "@");
}

+ (IMP)implementationToConstructDefinitionForSEL:(SEL)selWithAdvicePrefix
{
    return imp_implementationWithBlock((__bridge id)objc_unretainedPointer((TyphoonDefinition*)^(TyphoonAssembly* me)
    {
        NSString* key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selWithAdvicePrefix];
        return [me->_definitionBuilder builtDefinitionForKey:key];
    }));
}


/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self)
    {
        _definitionBuilder = [[TyphoonAssemblyDefinitionBuilder alloc] initWithAssembly:self];
        _adviser = [[TyphoonAssemblyAdviser alloc] init];
    }
    return self;
}

- (void)dealloc
{
    LogTrace(@"$$$$$$ %@ in dealloc!", [self class]);
    [TyphoonAssemblyAdviser undoAdviseMethods:self];
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)resolveCollaboratingAssemblies
{
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

#pragma mark - TyphoonBlockFactoryFriend
- (NSArray*)definitions
{
    return [_definitionBuilder builtDefinitions];
}

- (void)prepareForUse
{
//    self.definitionSelectors = [self.adviser enumerateDefinitionSelectors];
    self.definitionSelectors = [TyphoonAssemblyAdviser definitionSelectorsForAssembly:self];

    [TyphoonAssemblyAdviser adviseMethods:self];
}

@end