//
// Created by Aleksey Garbarev on 23.05.14.
//

#import "TyphoonDefinition+Tests.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonInjections.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByFactoryReference.h"
#import "TyphoonInjectionByObjectFromString.h"

@implementation TyphoonDefinition (Tests)

- (NSUInteger)numberOfMethodInjectionsByObjectFromString
{
    return [self numberOfMethodInjectionsOfKind:[TyphoonInjectionByObjectFromString class]];;
}

- (NSUInteger)numberOfPropertyInjectionsByObjectFromString
{
    return [self numberOfPropertyInjectionsOfKind:[TyphoonInjectionByObjectFromString class]];
}

- (NSUInteger)numberOfPropertyInjectionsByReference
{
    return [self numberOfPropertyInjectionsOfKind:[TyphoonInjectionByReference class]];
}

- (NSUInteger)numberOfPropertyInjectionsByObject
{
    return [self numberOfPropertyInjectionsOfKind:[TyphoonInjectionByObjectInstance class]];
}

- (NSUInteger)numberOfPropertyInjectionsOfKind:(Class)kind
{
    return [self numberOfInjections:TyphoonInjectionsEnumerationOptionProperties ofKind:kind];
}

- (NSUInteger)numberOfMethodInjectionsOfKind:(Class)kind
{
    return [self numberOfInjections:TyphoonInjectionsEnumerationOptionMethods ofKind:kind];
}

- (NSUInteger)numberOfInjections:(TyphoonInjectionsEnumerationOption)option ofKind:(Class)kind
{
    __block NSUInteger count = 0;
    [self enumerateInjectionsOfKind:kind options:option
                               usingBlock:^(id injection, id *injectionToReplace, BOOL *stop) {
        count++;
    }];
    return count;
}

@end