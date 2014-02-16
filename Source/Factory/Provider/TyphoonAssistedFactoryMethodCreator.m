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

#import "TyphoonAssistedFactoryMethodCreator.h"
#import "TyphoonAssistedFactoryMethodCreator+Private.h"

#import "TyphoonAssistedFactoryMethodBlock.h"
#import "TyphoonAssistedFactoryMethodInitializer.h"
#import "TyphoonAssistedFactoryMethodBlockCreator.h"
#import "TyphoonAssistedFactoryMethodInitializerCreator.h"


@implementation TyphoonAssistedFactoryMethodCreator

+ (instancetype)creatorFor:(id <TyphoonAssistedFactoryMethod>)factoryMethod
{
    if ([factoryMethod isKindOfClass:[TyphoonAssistedFactoryMethodBlock class]]) {
        return [[TyphoonAssistedFactoryMethodBlockCreator alloc] initWithFactoryMethod:factoryMethod];
    }
    else if ([factoryMethod isKindOfClass:[TyphoonAssistedFactoryMethodInitializer class]]) {
        return [[TyphoonAssistedFactoryMethodInitializerCreator alloc] initWithFactoryMethod:factoryMethod];
    }
    else {
        NSAssert(NO, @"Unknown TyphoonAssistedFactoryMethod subclass %@", NSStringFromClass([factoryMethod class]));
        return nil;
    }
}

- (instancetype)initWithFactoryMethod:(TyphoonAssistedFactoryMethodBlock *)factoryMethod
{
    self = [super init];
    if (self) {
        _factoryMethod = factoryMethod;
    }

    return self;
}

- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
        reason:@"You should not create instances of TyphoonAssistedFactoryMethodCreator directly" userInfo:nil];
}

- (struct objc_method_description)methodDescriptionFor:(SEL)methodName inProtocol:(Protocol *)protocol
{
    unsigned int methodCount = 0;
    struct objc_method_description *methodDescriptions = protocol_copyMethodDescriptionList(protocol, YES, YES, &methodCount);

    // Search for the right obcj_method_description
    struct objc_method_description methodDescription;
    BOOL found = NO;
    for (unsigned int idx = 0; idx < methodCount; idx++) {
        methodDescription = methodDescriptions[idx];
        if (methodDescription.name == methodName) {
            found = YES;
            break;
        }
    }
    NSCAssert(found, @"protocol doesn't support factory method with name %@", NSStringFromSelector(methodName));
    free(methodDescriptions);

    return methodDescription;
}

@end
