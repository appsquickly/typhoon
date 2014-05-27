//
// Created by Aleksey Garbarev on 27.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByConfig.h"
#import "TyphoonInjection.h"


@implementation TyphoonInjectionByConfig
{

}
- (instancetype)initWithConfigKey:(NSString *)configKey
{
    self = [super init];
    if (self) {
        _configKey = configKey;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByConfig *copied = [[TyphoonInjectionByConfig alloc] initWithConfigKey:self.configKey];
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    if (!self.configuredInjection) {
        [NSException raise:NSInternalInconsistencyException format:@"Value for config key %@ is not configured. Make sure that you applied TyphoonConfigPostProcessor.",self.configKey];
    }

    [self.configuredInjection valueToInjectWithContext:context completion:result];
}

@end