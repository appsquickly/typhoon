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

#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonAssistedFactoryMethodInitializerCreator.h"
#import "TyphoonAssistedFactoryMethodInitializer.h"

#include <objc/runtime.h>


@protocol TestProtocol <NSObject>

- (NSString *)dataStringWithEncoding:(NSStringEncoding)encoding;

@end

@interface TestClass : NSObject

@property (nonatomic, strong, readonly) NSData *data;

@end

@interface TyphoonAssistedFactoryMethodInitializerCreatorTest : SenTestCase
@end

@implementation TyphoonAssistedFactoryMethodInitializerCreatorTest
{
}

- (void)testExample
{
    TyphoonAssistedFactoryMethodInitializer *initializer = [[TyphoonAssistedFactoryMethodInitializer alloc] initWithFactoryMethod:@selector(dataStringWithEncoding:) returnType:[NSString class]];
    initializer.selector = @selector(initWithData:encoding:);
    [initializer injectParameterAtIndex:0 withProperty:@selector(data)];
    [initializer injectParameterAtIndex:1 withArgumentAtIndex:0];

    TyphoonAssistedFactoryMethodCreator *creator = [TyphoonAssistedFactoryMethodCreator creatorFor:initializer];

    [creator createFromProtocol:@protocol(TestProtocol) inClass:[TestClass class]];

    NSObject<TestProtocol> *t = (NSObject<TestProtocol> *)[[TestClass alloc] init];
    NSData *data = [@"Hello World!" dataUsingEncoding:NSUTF8StringEncoding];
    [t setValue:data forKey:@"data"];

    NSString *str = [t dataStringWithEncoding:NSUTF8StringEncoding];
    assertThat(str, equalTo(@"Hello World!"));
}

@end

@implementation TestClass
@end
