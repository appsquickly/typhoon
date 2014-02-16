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

#import "NSValue+TCFInstanceBuilder.h"
#import "TyphoonStringUtils.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>

#endif

#if TARGET_OS_MAC
#import <QuartzCore/QuartzCore.h>

#endif

@implementation NSValue (TCFInstanceBuilder)

- (void)typhoon_setAsArgumentForInvocation:(NSInvocation *)invocation atIndex:(NSUInteger)index
{
    const char *type = [self objCType];

    if (CStringEquals(type, @encode(void *))) {
        void *converted = [self pointerValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(NSRange))) {
        NSRange converted = [self rangeValue];
        [invocation setArgument:&converted atIndex:index];
    }
#if TARGET_OS_IPHONE
    else if (CStringEquals(type, @encode(CGPoint))) {
        CGPoint converted = [self CGPointValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(CGRect))) {
        CGRect converted = [self CGRectValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(CGSize))) {
        CGSize converted = [self CGSizeValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(CGAffineTransform))) {
        CGAffineTransform converted = [self CGAffineTransformValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(UIEdgeInsets))) {
        UIEdgeInsets converted = [self UIEdgeInsetsValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(UIOffset))) {
        UIOffset converted = [self UIOffsetValue];
        [invocation setArgument:&converted atIndex:index];
    }
#elif TARGET_OS_MAC
    else if (CStringEquals(type, @encode(CATransform3D))) {
        CATransform3D converted = [self CATransform3DValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(NSRect))) {
        NSRect converted = [self rectValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(NSSize))) {
        NSSize converted = [self sizeValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(NSPoint))) {
        NSPoint converted = [self pointValue];
        [invocation setArgument:&converted atIndex:index];
    }
#endif
    else {
        [NSException raise:@"InvalidValueType" format:@"Type '%s' is not supported.", type];
    }
}

@end

@implementation NSNumber (TCFInstanceBuilder)

- (void)typhoon_setAsArgumentForInvocation:(NSInvocation *)invocation atIndex:(NSUInteger)index
{
    const char *type = [self objCType];

    if (CStringEquals(type, @encode(int))) {
        int converted = [self intValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned int))) {
        unsigned int converted = [self unsignedIntValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(char))) {
        char converted = [self charValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned char))) {
        unsigned char converted = [self unsignedCharValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(bool))) {
        bool converted = [self boolValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(short))) {
        short converted = [self shortValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned short))) {
        unsigned short converted = [self unsignedShortValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(float))) {
        float converted = [self floatValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(double))) {
        double converted = [self doubleValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(long))) {
        long converted = [self longValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned long))) {
        unsigned long converted = [self unsignedLongValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(long long))) {
        long long converted = [self longLongValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else if (CStringEquals(type, @encode(unsigned long long))) {
        unsigned long long converted = [self unsignedLongLongValue];
        [invocation setArgument:&converted atIndex:index];
    }
    else {
        [NSException raise:@"InvalidNumberType" format:@"Type '%s' is not supported.", type];
    }
}

@end
