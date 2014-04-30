////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
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
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonAssemblyAdviser.h"
#import "TyphoonAssemblyDefinitionBuilder.h"
#import "TyphoonCollaboratingAssemblyPropertyEnumerator.h"
#import "TyphoonCollaboratingAssemblyProxy.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonObjectWithCustomInjection.h"
#import "TyphoonInjectionByComponentFactory.h"

static NSMutableArray *reservedSelectorsAsStrings;

@interface TyphoonAssembly () <TyphoonObjectWithCustomInjection>

@property(readwrite) NSSet *definitionSelectors;

@property(readonly) TyphoonAssemblyAdviser *adviser;

@end

@implementation TyphoonAssembly
{
    TyphoonAssemblyDefinitionBuilder *_definitionBuilder;
}


/* ====================================================================================================================================== */
#pragma mark - Class Methods

+ (TyphoonAssembly *)assembly
{
    TyphoonAssembly *assembly = [[self alloc] init];
    [assembly resolveCollaboratingAssemblies];
    return assembly;
}

+ (instancetype)defaultAssembly
{
    return (TyphoonAssembly *) [TyphoonComponentFactory defaultFactory];
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
    [self markSelectorReserved:@selector(asFactory)];
    [self markSelectorReserved:@selector(resolveCollaboratingAssemblies)];
}

+ (void)markSelectorReserved:(SEL)selector
{
    [self markSelectorReservedFromString:NSStringFromSelector(selector)];
}

+ (void)markSelectorReservedFromString:(NSString *)stringFromSelector
{
    [reservedSelectorsAsStrings addObject:stringFromSelector];
}

/* ====================================================================================================================================== */
#pragma mark - Instance Method Resolution
// handle definition method calls, mapping [self definitionA] to [self->_definitionBuilder builtDefinitionForKey:@"definitionA"]
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if ([self shouldProvideDynamicImplementationFor:sel]) {
        [self provideDynamicImplementationToConstructDefinitionForSEL:sel];
        return YES;
    }

    return [super resolveInstanceMethod:sel];
}

+ (BOOL)shouldProvideDynamicImplementationFor:(SEL)sel;
{
    return ([self selectorCorrespondsToDefinitionMethod:sel] && [TyphoonAssemblySelectorAdviser selectorIsAdvised:sel]);
}

+ (BOOL)selectorCorrespondsToDefinitionMethod:(SEL)sel
{
    return ![self selectorReservedOrPropertySetter:sel];
}

+ (BOOL)selectorReservedOrPropertySetter:(SEL)selector
{
    return [self selectorIsReserved:selector] || [self selectorIsPropertySetter:selector];
}

+ (BOOL)selectorIsReserved:(SEL)selector
{
    NSString *selectorString = NSStringFromSelector(selector);
    return [reservedSelectorsAsStrings containsObject:selectorString];
}

+ (BOOL)selectorIsPropertySetter:(SEL)selector
{
    NSString *selectorString = NSStringFromSelector(selector);
    return [selectorString hasPrefix:@"set"] && [selectorString hasSuffix:@":"];
}

+ (void)provideDynamicImplementationToConstructDefinitionForSEL:(SEL)sel;
{
    SEL originalSel = NSSelectorFromString([TyphoonAssemblySelectorAdviser keyForAdvisedSEL:sel]);
    
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    NSUInteger numberOfArguments = method_getNumberOfArguments(originalMethod);
    
    const char *types = [ArgumentTypesForMethod(originalMethod) cStringUsingEncoding:NSASCIIStringEncoding];
    
    switch (numberOfArguments-2) {
        case 0:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinition, types);
            break;
        case 1:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch1Argument, types);
            break;
        case 2:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch2Arguments, types);
            break;
        case 3:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch3Arguments, types);
            break;
        case 4:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch4Arguments, types);
            break;
        case 5:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch5Arguments, types);
            break;
        case 6:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch6Arguments, types);
            break;
        case 7:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch7Arguments, types);
            break;
        case 8:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch8Arguments, types);
            break;
        case 9:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch9Arguments, types);
            break;
        case 10:
            class_addMethod(self, sel, (IMP)&ImplementationToConstructDefinitionAndCatch10Arguments, types);
            break;
        default:
            NSAssert(NO, @"Typhoon not suppot more than %d runtime arguments yet",(int)numberOfArguments-2);
            break;
    }
}

//TODO: fix it with NSInvocation approach
#pragma mark - Temporary Ugly Fix

static id ImplementationToConstructDefinition(TyphoonAssembly *me, SEL selector)
{
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:nil];
}

static id ImplementationToConstructDefinitionAndCatch1Argument(TyphoonAssembly *me, SEL selector, id obj)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}

static id ImplementationToConstructDefinitionAndCatch2Arguments(TyphoonAssembly *me, SEL selector, id obj, id obj2)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj, obj2];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}

static id ImplementationToConstructDefinitionAndCatch3Arguments(TyphoonAssembly *me, SEL selector, id obj, id obj2, id obj3)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj, obj2, obj3];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}

static id ImplementationToConstructDefinitionAndCatch4Arguments(TyphoonAssembly *me, SEL selector, id obj, id obj2, id obj3, id obj4)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj, obj2, obj3, obj4];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}
static id ImplementationToConstructDefinitionAndCatch5Arguments(TyphoonAssembly *me, SEL selector, id obj, id obj2, id obj3, id obj4, id obj5)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj, obj2, obj3, obj4, obj5];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}

static id ImplementationToConstructDefinitionAndCatch6Arguments(TyphoonAssembly *me, SEL selector, id obj, id obj2, id obj3, id obj4, id obj5, id obj6)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj, obj2, obj3, obj4, obj5, obj6];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}

static id ImplementationToConstructDefinitionAndCatch7Arguments(TyphoonAssembly *me, SEL selector, id obj, id obj2, id obj3, id obj4, id obj5, id obj6, id obj7)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj, obj2, obj3, obj4, obj5, obj6, obj7];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}

static id ImplementationToConstructDefinitionAndCatch8Arguments(TyphoonAssembly *me, SEL selector, id obj, id obj2, id obj3, id obj4, id obj5, id obj6, id obj7, id obj8)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj, obj2, obj3, obj4, obj5, obj6, obj7, obj8];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}

static id ImplementationToConstructDefinitionAndCatch9Arguments(TyphoonAssembly *me, SEL selector, id obj, id obj2, id obj3, id obj4, id obj5, id obj6, id obj7, id obj8, id obj9)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj, obj2, obj3, obj4, obj5, obj6, obj7, obj8, obj9];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}

static id ImplementationToConstructDefinitionAndCatch10Arguments(TyphoonAssembly *me, SEL selector, id obj, id obj2, id obj3, id obj4, id obj5, id obj6, id obj7, id obj8, id obj9, id obj10)
{
    TyphoonRuntimeArguments *args = [TyphoonRuntimeArguments argumentsWithSelector:selector arguments:obj, obj2, obj3, obj4, obj5, obj6, obj7, obj8, obj9, obj10];
    
    NSString *key = [TyphoonAssemblySelectorAdviser keyForAdvisedSEL:selector];
    return [me->_definitionBuilder builtDefinitionForKey:key args:args];
}

static NSString *ArgumentTypesForMethod(Method method)
{
    NSMutableString *types = [NSMutableString new];
    
    unsigned int argc = method_getNumberOfArguments(method);
    
    char buffer[25];
    method_getReturnType(method, buffer, 25);
    [types appendString:[NSString stringWithCString:buffer encoding:NSASCIIStringEncoding]];
    
    for (int index = 0; index < argc; index++) {
        char buffer[25];
        method_getArgumentType(method, index, buffer, 25);
        [types appendString:[NSString stringWithCString:buffer encoding:NSASCIIStringEncoding]];
    }
    
    return types;
}

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)init
{
    self = [super init];
    if (self) {
        _definitionBuilder = [[TyphoonAssemblyDefinitionBuilder alloc] initWithAssembly:self];
        _adviser = [[TyphoonAssemblyAdviser alloc] initWithAssembly:self];
    }
    return self;
}

- (void)dealloc
{
    [TyphoonAssemblyAdviser undoAdviseMethods:self];
}

/* ====================================================================================================================================== */
#pragma mark - <TyphoonObjectWithCustomInjection>

- (id <TyphoonPropertyInjection, TyphoonParameterInjection>)typhoonCustomObjectInjection
{
    return [[TyphoonInjectionByComponentFactory alloc] init];
}

/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)resolveCollaboratingAssemblies
{
    TyphoonCollaboratingAssemblyPropertyEnumerator
        *enumerator = [[TyphoonCollaboratingAssemblyPropertyEnumerator alloc] initWithAssembly:self];

    for (NSString *propertyName in enumerator.collaboratingAssemblyProperties) {
        [self setCollaboratingAssemblyProxyOnPropertyNamed:propertyName];
    }
}

- (void)setCollaboratingAssemblyProxyOnPropertyNamed:(NSString *)name
{
    [self setValue:[TyphoonCollaboratingAssemblyProxy proxy] forKey:name];
}

- (TyphoonComponentFactory *)asFactory
{
    return (id)self;
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (NSArray *)definitions
{
    return [_definitionBuilder builtDefinitions];
}

- (TyphoonDefinition *)definitionForKey:(NSString *)key
{
    for (TyphoonDefinition *definition in [self definitions]) {
        if ([definition.key isEqualToString:key]) {
            return definition;
        }
    }
    return nil;
}

- (void)prepareForUse
{
    self.definitionSelectors = [self.adviser enumerateDefinitionSelectors];
    [self.adviser adviseAssembly];
}


@end