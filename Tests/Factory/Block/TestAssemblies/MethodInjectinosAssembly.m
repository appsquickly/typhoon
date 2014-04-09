//
//  MethonInjectinosAssembly.m
//  Tests
//
//  Created by Aleksey Garbarev on 27.03.14.
//
//

#import "MethodInjectinosAssembly.h"
#import "Knight.h"
#import "MiddleAgesAssembly.h"

@interface MethodInjectinosAssembly ()
@property (nonatomic, strong) MiddleAgesAssembly *middleAge;
@end

@implementation MethodInjectinosAssembly

- (id)knightInjectedByMethod
{
    return [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setQuest:andDamselsRescued:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:self.middleAge.defaultQuest];
            [method injectParameterWith:@3];
        }];
    }];
}

- (id)knightWithCircularDependency
{
    return [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectInitializer:@selector(initWithQuest:favoriteDamsels:) parameters:^(TyphoonMethod *initializer) {
            [initializer injectParameterWith:self.middleAge.defaultQuest];
            [initializer injectParameterWith:@[
                [self anotherKnightWithCircularDependency],
                [self knightInjectedByMethod]
            ]];
        }];
    }];
}

- (id)anotherKnightWithCircularDependency
{
    return [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setFoobar:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self knightWithCircularDependency]];
        }];
    }];
}

- (id)knightWithMethodRuntimeFoo:(NSString *)foo
{
    return [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setFoobar:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:foo];
        }];
    }];
}

- (id)knightWithMethodFoo:(NSObject *)foo
{
    return [TyphoonDefinition withClass:[Knight class] injections:^(TyphoonDefinition *definition) {
        [definition injectMethod:@selector(setFoobar:andHasHorse:friends:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:foo];
            [method injectParameterWith:@YES];
            [method injectParameterWith:[NSSet setWithObjects:[self knightInjectedByMethod], [self.middleAge anotherKnight], nil]];
        }];
    }];
}

@end
