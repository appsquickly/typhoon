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

#import "TyphoonAbstractInjectedProperty.h"

@implementation TyphoonAbstractInjectedProperty

- (NSString*)name
{
    [NSException raise:NSInvalidArgumentException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
    return nil;
}

- (TyphoonPropertyInjectionType)injectionType
{
    [NSException raise:NSInvalidArgumentException format:@"%@ is abstract", NSStringFromSelector(_cmd)];
    return 0;
}

- (BOOL)isEqual:(id)other
{
    if (other == self)
    {
            return YES;
    }
    if (!other || ![[other class] isEqual:[self class]])
    {
            return NO;
    }

    return [self isEqualToBase:other];
}

- (BOOL)isEqualToBase:(TyphoonAbstractInjectedProperty*)base
{
    if (self == base)
    {
            return YES;
    }
    if (base == nil)
    {
            return NO;
    }
    if (self.name != base.name && ![self.name isEqualToString:base.name])
    {
            return NO;
    }
    return YES;
}

- (NSUInteger)hash
{
    return [self.name hash];
}

@end