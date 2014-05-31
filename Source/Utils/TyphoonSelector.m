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



#import "TyphoonSelector.h"
#import <objc/runtime.h>

@interface TyphoonSelector ()

@end


@implementation TyphoonSelector
{
    
}

+ (TyphoonSelector *)selectorWithName:(NSString *)aName
{
    return [[self alloc] initWithName:aName];
}

+ (TyphoonSelector *)selectorWithSEL:(SEL)aSelector
{
    return [[self alloc] initWithSEL:aSelector];
}

- (id)initWithName:(NSString *)aName
{
    return [self initWithSEL:NSSelectorFromString(aName)];
}

- (id)initWithSEL:(SEL)aSelector
{
    self = [super init];
    if (self) {
        _selector = aSelector;
    }
    return self;
}

- (NSString *)description
{
    // <TyphoonSelector: 0x00000 SEL named: 'aDefinitionMethod'>
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: %p SEL named: '%@'>", NSStringFromClass([self class]), self,
                                    NSStringFromSelector(self.selector)];
    return description;
}

- (NSUInteger)hash
{
    return (NSUInteger) sel_getName(self.selector);
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    }
    if (!other || [other class] != [self class]) {
        return NO;
    }

    return [self isEqualToSelector:(TyphoonSelector *) other];
}

- (BOOL)isEqualToSelector:(TyphoonSelector *)wrappedSelector
{
    return sel_isEqual(self.selector, wrappedSelector.selector);
}


@end