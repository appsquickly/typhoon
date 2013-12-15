//
// Created by Robert Gilliam on 12/14/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonWrappedSelector.h"

@interface TyphoonWrappedSelector()

@end


@implementation TyphoonWrappedSelector
{

}

+ (TyphoonWrappedSelector*)withName:(NSString*)string
{
    return [[self alloc] initWithName:string];
}

- (id)initWithName:(NSString*)string
{
    return [self initWithSelector:NSSelectorFromString(string)];
}

+ (TyphoonWrappedSelector*)wrappedSelectorWithSelector:(SEL)pSelector
{
    return [[self alloc] initWithSelector:pSelector];
}

- (id)initWithSelector:(SEL)pSelector
{
    self = [super init];
    if (self) {
        _selector = pSelector;
    }
    return self;
}

// <TyphoonWrappedSelector: 0x00000 SEL named: 'aDefinitionMethod'>
- (NSString*)description
{
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: 0x%x SEL named: '%@", NSStringFromClass([self class]), self, NSStringFromSelector(self.selector)];

    [description appendString:@">"];
    return description;
}

@end