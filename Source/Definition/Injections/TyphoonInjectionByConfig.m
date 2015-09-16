////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonInjectionByConfig.h"
#import "TyphoonInjection.h"
#import "TyphoonUtils.h"


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

- (BOOL)isEqualToCustom:(TyphoonInjectionByConfig *)injection
{
    return [self.configKey isEqualToString:injection.configKey];
}

- (void)valueToInjectWithContext:(TyphoonInjectionContext *)context completion:(TyphoonInjectionValueBlock)result
{
    if (!self.configuredInjection) {
        [NSException raise:NSInternalInconsistencyException format:@"Value for config key %@ is not configured. Make sure that you applied TyphoonConfigPostProcessor.",self.configKey];
    }

    [self.configuredInjection valueToInjectWithContext:context completion:result];
}

- (NSUInteger)customHash
{
    return [self.configKey hash];
}

@end
