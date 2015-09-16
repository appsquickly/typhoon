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
    NSDictionary *dictionary = nil;
    
    // remove deprecated warning when targeting iOS 8 + and OSX 10.6 +
#if (TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8) || (TARGET_OS_MAC && MAC_OS_X_VERSION_MIN_REQUIRED >= MAC_OS_X_VERSION_10_10)
    NSError * error = nil;
    dictionary = [NSPropertyListSerialization propertyListWithData:[resource data]
                                                           options:NSPropertyListImmutable
                                                            format:NULL
                                                             error:&error];
    if (error != nil) {
        errorString = [error localizedDescription];
    }
#else
    dictionary = [NSPropertyListSerialization propertyListFromData:[resource data]
                                                  mutabilityOption:NSPropertyListImmutable
                                                            format:NULL
                                                  errorDescription:&errorString];
#endif
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
