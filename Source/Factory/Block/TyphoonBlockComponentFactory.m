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
#import <Typhoon/TyphoonInitializer+InstanceBuilder.h>
#import <Typhoon/TyphoonCollaboratingAssemblyProxy.h>
#import "TyphoonBlockComponentFactory.h"
#import "TyphoonAssembly.h"
#import "TyphoonDefinition.h"
#import "OCLogTemplate.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"
#import "TyphoonInitializer.h"
#import "TyphoonInjectedParameter.h"
#import "TyphoonParameterInjectedByReference.h"
#import "TyphoonPropertyInjectedByReference.h"

NSString const * TyphoonAssemblyInvalidException = @"TyphoonAssemblyInvalidException";

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
            [self buildAssembly:assembly];
        }
    }
    return self;
}

- (void)buildAssembly:(TyphoonAssembly*)assembly
{
    LogTrace(@"Building assembly: %@", NSStringFromClass([assembly class]));
    [self assertIsAssembly:assembly];

    [assembly prepareForUse];
    [self registerAllDefinitions:assembly];
    [self verifyDefinitionsDoNotDirectlyCallOtherAssemblies:assembly];
}

- (void)verifyDefinitionsDoNotDirectlyCallOtherAssemblies:(TyphoonAssembly *)assembly
{
    // all injected initializers and properties must have a key that is either:
    // on a definition that is a TyphoonCollaboratingAssemblyProxy
    // on that assembly itself

    for (TyphoonDefinition* definition in [assembly definitions]) {
        // initializer:
//        TyphoonInitializer *initializer = [definition initializer];
//        for (id <TyphoonInjectedParameter> parameter in initializer.injectedParameters) {
//            // if it has a key...
//            if (parameter.type == TyphoonParameterInjectionTypeReference) {
//                if ([parameterIsFromCollaboartingAssemblyProxy:(TyphoonParameterInjectedByReference *)parameter]) {
//                    // OK
//                }else if ([parameterIsOnAssemblyItself:(TyphoonParameterInjectedByReference *)parameter]) {
//                    // OK
//                }else{
//                    // NOT okay! Must be on a different assembly!
//                    [self onInitializerInjectionWithDefinitionFromDifferentAssemblyDetected]; // throw exception!
//                }
//
//                NSString *key = [(TyphoonParameterInjectedByReference *)parameter reference];
//
//            }
//        }

        TyphoonInitializer *initializer = [definition initializer];
        for (id <TyphoonInjectedParameter> parameter in initializer.injectedParameters) {
            if (parameter.type == TyphoonParameterInjectionTypeReference) {
                if ([self parameter:(TyphoonParameterInjectedByReference *)parameter isFromDifferentAssemblyThan:assembly]) {
                    [self onInitializerInjectionWithDefinitionNamed:definition.key fromDifferentAssemblyDetected:assembly];// throw exception!
                }
            }
        }

        // check for property injection problems
        for (id <TyphoonInjectedProperty> property in definition.injectedProperties) {
            if (property.injectionType == TyphoonPropertyInjectionTypeByReference) {
                if ([self property:(TyphoonPropertyInjectedByReference *)property isFromDifferentAssemblyThan:assembly]) {
                   [self onPropertyInjectionWithDefinitionNamed:definition.key fromDifferentAssemblyDetected:assembly];// throw exception!
                }
            }
        }
    }
}

- (void)onInitializerInjectionWithDefinitionNamed:(NSString *)key fromDifferentAssemblyDetected:(TyphoonAssembly *)detected {
    [NSException raise:TyphoonAssemblyInvalidException format:@"The definition '%@' on assembly '%@' attempts to perform initializer injection with an instance of a different assembly.\nUse a collaborating assembly proxy instead.", key, NSStringFromClass([detected class])];
}

- (BOOL)parameter:(TyphoonParameterInjectedByReference *)parameter isFromDifferentAssemblyThan:(TyphoonAssembly *)assembly {
    BOOL fromSameAssembly = [self parameterIsFromCollaboratingAssemblyProxy:parameter] || [self parameterIsOnAssemblyItself:parameter currentAssembly:assembly];

    return !fromSameAssembly;
}

- (BOOL)parameterIsOnAssemblyItself:(TyphoonParameterInjectedByReference *)reference currentAssembly:(TyphoonAssembly *)assembly {
    return [assembly definitionForKey:reference.reference] != nil;
}

- (BOOL)parameterIsFromCollaboratingAssemblyProxy:(TyphoonParameterInjectedByReference *)reference {
    return reference.fromCollaboratingAssemblyProxy;
}

- (BOOL)property:(TyphoonPropertyInjectedByReference *)property isFromDifferentAssemblyThan:(TyphoonAssembly *)assembly {
    BOOL fromSameAssembly = [self propertyIsFromCollaboratingAssemblyProxy:property] || [self propertyIsOnAssemblyItself:property currentAssembly:assembly];

    return !fromSameAssembly;
}

- (void)onPropertyInjectionWithDefinitionNamed:(NSObject *)key fromDifferentAssemblyDetected:(TyphoonAssembly *)assembly
{
    [NSException raise:TyphoonAssemblyInvalidException format:@"The definition '%@' on assembly '%@' attempts to perform property injection with an instance of a different assembly.\nUse a collaborating assembly proxy instead.", key, NSStringFromClass([assembly class])];
}

- (BOOL)propertyIsOnAssemblyItself:(TyphoonPropertyInjectedByReference *)reference currentAssembly:(TyphoonAssembly *)currentAssembly {
    return [currentAssembly definitionForKey:reference.reference] != nil;
}

- (BOOL)propertyIsFromCollaboratingAssemblyProxy:(TyphoonPropertyInjectedByReference *)reference {
    return reference.fromCollaboratingAssemblyProxy;
}

- (void)assertIsAssembly:(TyphoonAssembly*)assembly
{
    if (![assembly isKindOfClass:[TyphoonAssembly class]]) //
    {
        [NSException raise:NSInvalidArgumentException format:@"Class '%@' is not a sub-class of %@",
                                                             NSStringFromClass([assembly class]),
                                                             NSStringFromClass([TyphoonAssembly class])];
    }
}

- (void)registerAllDefinitions:(TyphoonAssembly*)assembly
{
    NSArray* definitions = [assembly definitions];
    for (TyphoonDefinition* definition in definitions)
    {
        [self register:definition];
    }
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

@end