//
// Created by Aleksey Garbarev on 23.05.14.
//

#import <Foundation/Foundation.h>
#import <Typhoon/TyphoonDefinition.h>

@interface TyphoonDefinition (Tests)

- (NSUInteger)numberOfMethodInjectionsByObjectFromString;

- (NSUInteger)numberOfPropertyInjectionsByObjectFromString;

- (NSUInteger)numberOfPropertyInjectionsByReference;

- (NSUInteger)numberOfPropertyInjectionsByObject;

@end