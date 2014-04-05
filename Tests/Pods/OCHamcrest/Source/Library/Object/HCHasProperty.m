//
//  OCHamcrest - HCHasProperty.m
//  Copyright 2012 hamcrest.org. See LICENSE.txt
//
//  Created by: Justin Shacklette
//

#import "HCHasProperty.h"

#import "HCDescription.h"
#import "HCRequireNonNilObject.h"
#import "HCWrapInMatcher.h"


@implementation HCHasProperty

+ (id)hasProperty:(NSString *)property value:(id<HCMatcher>)aValueMatcher
{
    return [[self alloc] initWithProperty:property value:aValueMatcher];
}

- (id)initWithProperty:(NSString *)property value:(id<HCMatcher>)aValueMatcher
{
    HCRequireNonNilObject(property);
    
    self = [super init];
    if (self != nil)
    {
        propertyName = [property copy];
        valueMatcher = aValueMatcher;
    }
    return self;
}

- (BOOL)matches:(id)item
{
    SEL propertyGetter = NSSelectorFromString(propertyName);
    if (![item respondsToSelector:propertyGetter])
        return NO;

    id propertyValue = [self objectFromInvokingSelector:propertyGetter onObject:item];
    return [valueMatcher matches:propertyValue];
}

- (id)objectFromInvokingSelector:(SEL)selector onObject:(id)object
{
    NSMethodSignature *getterSignature = [object methodSignatureForSelector:selector];
    NSInvocation *getterInvocation = [NSInvocation invocationWithMethodSignature:getterSignature];
    [getterInvocation setTarget:object];
    [getterInvocation setSelector:selector];
    [getterInvocation invoke];
    
    char charValue;
    int intValue;
    short shortValue;
    long longValue;
    long long longLongValue;
    unsigned char unsignedCharValue;
    unsigned int unsignedIntValue;
    unsigned short unsignedShortValue;
    unsigned long unsignedLongValue;
    unsigned long long unsignedLongLongValue;
    float floatValue;
    double doubleValue;

    __unsafe_unretained id result = nil;
    const char *argType = [getterSignature methodReturnType];
    switch (argType[0])
    {
        case 'c':
            [getterInvocation getReturnValue:&charValue];
            result = @(charValue);
            break;
            
        case 'i':
            [getterInvocation getReturnValue:&intValue];
            result = @(intValue);
            break;
            
        case 's':
            [getterInvocation getReturnValue:&shortValue];
            result = @(shortValue);
            break;
            
        case 'l':
            [getterInvocation getReturnValue:&longValue];
            result = @(longValue);
            break;
            
        case 'q':
            [getterInvocation getReturnValue:&longLongValue];
            result = @(longLongValue);
            break;
            
        case 'C':
            [getterInvocation getReturnValue:&unsignedCharValue];
            result = @(unsignedCharValue);
            break;
            
        case 'I':
            [getterInvocation getReturnValue:&unsignedIntValue];
            result = @(unsignedIntValue);
            break;
            
        case 'S':
            [getterInvocation getReturnValue:&unsignedShortValue];
            result = @(unsignedShortValue);
            break;
            
        case 'L':
            [getterInvocation getReturnValue:&unsignedLongValue];
            result = @(unsignedLongValue);
            break;
            
        case 'Q':
            [getterInvocation getReturnValue:&unsignedLongLongValue];
            result = @(unsignedLongLongValue);
            break;
            
        case 'f':
            [getterInvocation getReturnValue:&floatValue];
            result = @(floatValue);
            break;
            
        case 'd':
            [getterInvocation getReturnValue:&doubleValue];
            result = @(doubleValue);
            break;
            
        case '@':
            [getterInvocation getReturnValue:&result];
            break;
    }
    
    return result;
}

- (void)describeTo:(id<HCDescription>)description
{
    [[[[description appendText:@"an object with "]
                    appendText:propertyName]
                    appendText:@" "]
                    appendDescriptionOf:valueMatcher];
}
@end


#pragma mark -

id<HCMatcher> HC_hasProperty(NSString *name, id valueMatch)
{
    return [HCHasProperty hasProperty:name value:HCWrapInMatcher(valueMatch)];
}
