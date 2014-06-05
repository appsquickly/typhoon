//
// Created by Aleksey Garbarev on 27.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonPlistStyleConfiguration.h"
#import "TyphoonResource.h"


@implementation TyphoonPlistStyleConfiguration
{
    NSMutableDictionary *_properties;
}

- (id)init
{
    self = [super init];
    if (self) {
        _properties = [NSMutableDictionary new];
    }
    return self;
}

- (void)appendResource:(id<TyphoonResource>)resource
{
    NSString *errorString = nil;
    NSDictionary *dictionary = [NSPropertyListSerialization propertyListFromData:[resource data]
                                                                mutabilityOption:NSPropertyListImmutable
                                                                          format:NULL
                                                                errorDescription:&errorString];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        [NSException raise:NSInvalidArgumentException format:@"Root plist object must be a dictionary"];
    }

    if (!errorString) {
        [_properties addEntriesFromDictionary:dictionary];
    } else {
        [NSException raise:NSInvalidArgumentException format:@"Can't prase plist configuration file: %@", errorString];
    }
}

- (id)objectForKey:(NSString *)key
{
    return [_properties valueForKeyPath:key];
}

@end