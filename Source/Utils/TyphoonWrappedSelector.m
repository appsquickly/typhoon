////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonWrappedSelector.h"

@interface TyphoonWrappedSelector()

@end


@implementation TyphoonWrappedSelector
{

}

+ (TyphoonWrappedSelector*)wrappedSelectorWithName:(NSString*)string
{
    return [[self alloc] initWithName:string];
}

+ (TyphoonWrappedSelector*)wrappedSelectorWithSelector:(SEL)pSelector
{
    return [[self alloc] initWithSelector:pSelector];
}

- (id)initWithName:(NSString*)string
{
    return [self initWithSelector:NSSelectorFromString(string)];
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