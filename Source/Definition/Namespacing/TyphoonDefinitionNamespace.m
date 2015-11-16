////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonDefinitionNamespace.h"

static NSString *const TyphoonDefinitionGlobalNamespace = @"TyphoonDefinitionGlobalNamespace";

@interface TyphoonDefinitionNamespace ()

@property (strong, nonatomic, readwrite) NSString *key;

@end

@implementation TyphoonDefinitionNamespace

+ (instancetype)globalNamespace {
    return [self namespaceWithKey:TyphoonDefinitionGlobalNamespace];
}

+ (instancetype)namespaceWithKey:(NSString *)key {
    return [[[self class] alloc] initWithKey:key];
}

- (instancetype)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
        _key = key;
    }
    return self;
}

- (BOOL)isGlobalNamespace {
    return [self.key isEqualToString:TyphoonDefinitionGlobalNamespace];
}

- (NSUInteger)hash
{
    return [self.key hash];
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }
    
    return [self.key isEqualToString:((TyphoonDefinitionNamespace *)other).key];
}

@end
