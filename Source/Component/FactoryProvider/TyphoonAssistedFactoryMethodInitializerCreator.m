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

#import "TyphoonAssistedFactoryMethodInitializerCreator.h"
#import "TyphoonAssistedFactoryMethodCreator+Private.h"

#import "TyphoonAssistedFactoryMethodClosure.h"
#import "TyphoonAssistedFactoryMethodInitializer.h"

/*
 * The closures must live as long as someone can make a call to the factory
 * methods. Since the classes are not built and destroyed all the time in the
 * Cocoa runtime, this cache will store all the closures for all the life of the
 * application.
 */
static NSMutableDictionary *sFactoryMethodClosures = nil;


@interface TyphoonAssistedFactoryMethodInitializerCreator ()

@property (nonatomic, strong) TyphoonAssistedFactoryMethodInitializer *factoryMethod;

@end


@implementation TyphoonAssistedFactoryMethodInitializerCreator

+ (void)initialize
{
  if (self == [TyphoonAssistedFactoryMethodInitializerCreator class])
  {
    sFactoryMethodClosures = [[NSMutableDictionary alloc] init];
  }
}

- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass
{
    struct objc_method_description methodDescription = [self methodDescriptionFor:self.factoryMethod.factoryMethod inProtocol:protocol];
    TyphoonAssistedFactoryMethodClosure *closure = [[TyphoonAssistedFactoryMethodClosure alloc] initWithInitializer:self.factoryMethod methodDescription:methodDescription];
    NSString *key = [NSString stringWithFormat:@"%s %s",
                     class_getName(self.factoryMethod.returnType),
                     sel_getName(self.factoryMethod.factoryMethod)];
    sFactoryMethodClosures[key] = closure;
    class_addMethod(factoryClass, methodDescription.name, closure.fptr, methodDescription.types);
}

@end
