//
//  TyphoonAssemblyTests.m
//  Tests
//
//  Created by Robert Gilliam on 8/1/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import <TyphoonAssembly.h>
#import "MiddleAgesAssembly.h"
#import <TyphoonAssemblySelectorWrapper.h>

@interface TyphoonAssemblyTests : SenTestCase

@end



@implementation TyphoonAssemblyTests

- (void)test_returns_method_signature_for_wrapped_selector;
{
    MiddleAgesAssembly *assembly = [[MiddleAgesAssembly alloc] init];
    NSMethodSignature *signature = [assembly methodSignatureForSelector:[TyphoonAssemblySelectorWrapper wrappedSELForSEL:@selector(knight)]];
    assertThat(signature, notNilValue());
    STAssertEquals([signature numberOfArguments], (NSUInteger)2, nil);
}

@end
