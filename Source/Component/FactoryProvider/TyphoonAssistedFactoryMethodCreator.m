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

#import "TyphoonAssistedFactoryMethodBlock.h"
#import "TyphoonAssistedFactoryMethodInitializer.h"
#import "TyphoonAssistedFactoryMethodBlockCreator.h"
#import "TyphoonAssistedFactoryMethodInitializerCreator.h"


@implementation TyphoonAssistedFactoryMethodCreator

+ (instancetype)creatorFor:(id<TyphoonAssistedFactoryMethod>)factoryMethod
{
    if ([factoryMethod isKindOfClass:[TyphoonAssistedFactoryMethodBlock class]]) {
        return [[TyphoonAssistedFactoryMethodBlockCreator alloc]
                initWithFactoryMethod:factoryMethod];
    } else if ([factoryMethod isKindOfClass:[TyphoonAssistedFactoryMethodBlock class]]) {
        return [[TyphoonAssistedFactoryMethodInitializerCreator alloc]
                initWithFactoryMethod:factoryMethod];
    } else {
      NSAssert(NO, @"this branch should not be reached");
      return nil;
    }
}

- (instancetype)initWithFactoryMethod:(TyphoonAssistedFactoryMethodBlock *)factoryMethod
{
  self = [super init];
  if (self)
  {
    _factoryMethod = factoryMethod;
  }

  return self;
}

- (void)createFromProtocol:(Protocol *)protocol inClass:(Class)factoryClass
{
    @throw [NSException
            exceptionWithName:NSInternalInconsistencyException
            reason:@"You should not create instances of TyphoonAssistedFactoryMethodCreator directly"
            userInfo:nil];
}

@end
