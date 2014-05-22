//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonJsonStyleConfiguration.h"
#import "TyphoonResource.h"


@implementation TyphoonJsonStyleConfiguration
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
    NSData *resourceData = [resource data];

    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:resourceData options:NSJSONReadingAllowFragments error:&error];

    if (!error) {
        [_properties addEntriesFromDictionary:dictionary];
    } else {
        NSLog(@"ERROR: Can't parse JSON resource: %@",error);
    }
}

- (id)objectForKey:(NSString *)key
{
    return [_properties valueForKeyPath:key];
}

@end