////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonInjectionPrimitiveEncoder.h"
#import "TyphoonInjectionByObjectInstance.h"
#import "TyphoonInjectionByRuntimeArgument.h"
#import "TyphoonInjectionByReference.h"
#import "TyphoonInjectionByCollection.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonDefinition+InstanceBuilder.h"
#import "TyphoonDefinition+Infrastructure.h"

@interface TyphoonInjectionPrimitiveEncoder ()

@property (nonatomic, readonly) unsigned char shiftValue;

@end


@implementation TyphoonInjectionPrimitiveEncoder

- (unsigned char)shiftValue
{
    return self.shifted ? 1 : 0;
}

- (unsigned char)encodeRuntimeArgumentIndex:(NSUInteger)index
{
    return (unsigned char)index + 1 + self.shiftValue;
}

- (NSNumber *)decodeRuntimeArgumentIndex:(unsigned char)encodedValue
{
    NSInteger index = (NSInteger)encodedValue - 1 - self.shiftValue;
    return (index >= 0) ? @(index) : nil;
}

- (void)decodeInjectionEnumeration:(id<TyphoonInjectionEnumeration>)enumeration withBlock:(BOOL (^)(id<NSCopying> key, id decodedInjection))block
{
    NSInteger currentIndex = 0;
    
    [self decodeInjectionsOnEnumeration:enumeration currentIndex:&currentIndex withBlock:^BOOL(NSInteger index, id decodedInjection) {
        return block(@(index), decodedInjection);
    }];
}

#pragma mark - Private

- (void)decodeInjectionsOnEnumeration:(id<TyphoonInjectionEnumeration>)enumeration currentIndex:(NSInteger *)currentIndex
                            withBlock:(BOOL (^)(NSInteger index, id decodedInjection))block
{
    [enumeration enumerateInjectionsOfKind:[TyphoonInjectionByObjectInstance class] options:TyphoonInjectionsEnumerationOptionAll usingBlock:^(TyphoonInjectionByObjectInstance *injection, __autoreleasing id *injectionToReplace, BOOL *stop) {
        id decodedInjection = [self decodeInjection:injection];
        if (decodedInjection) {
            BOOL shouldReplace = block(*currentIndex, decodedInjection);
            if (shouldReplace) {
                *injectionToReplace = decodedInjection;
            }
        }
        (*currentIndex)++;
    }];
    
    [enumeration enumerateInjectionsOfKind:[TyphoonInjectionByReference class] options:TyphoonInjectionsEnumerationOptionAll usingBlock:^(TyphoonInjectionByReference *injection, __autoreleasing id *injectionToReplace, BOOL *stop) {
        [self decodeInjectionsOnEnumeration:injection.referenceArguments currentIndex:currentIndex withBlock:block];
    }];
    
    [enumeration enumerateInjectionsOfKind:[TyphoonInjectionByCollection class] options:TyphoonInjectionsEnumerationOptionAll usingBlock:^(TyphoonInjectionByCollection *injection, __autoreleasing id *injectionToReplace, BOOL *stop) {
        [self decodeInjectionsOnEnumeration:injection currentIndex:currentIndex withBlock:block];
    }];
}

- (id)decodeInjection:(TyphoonInjectionByObjectInstance *)injection
{
    if (![injection.objectInstance isKindOfClass:[NSValue class]]) {
        return nil;
    }
    
    NSValue *boxedEncodedValue = injection.objectInstance;
    
    NSUInteger argumentSize;
    NSGetSizeAndAlignment(boxedEncodedValue.objCType, &argumentSize, NULL);
    
    void *buffer = malloc(argumentSize);
    [boxedEncodedValue getValue:buffer];
    unsigned char encodedValue = *((unsigned char *)buffer);
    free(buffer);
    
    
    NSNumber *decodedRuntimeArgumentIndex = [self decodeRuntimeArgumentIndex:encodedValue];
    if (decodedRuntimeArgumentIndex) {
        return [[TyphoonInjectionByRuntimeArgument alloc] initWithArgumentIndex:decodedRuntimeArgumentIndex.unsignedIntegerValue];
    }
    
    // TODO: config
    
    return nil;
}

@end


@implementation TyphoonInjectionPrimitiveEncoder (ThreadLocal)

static NSString * const kCurrentEncoderKey = @"TyphoonInjectionPrimitiveEncoder"; // TODO

+ (instancetype)currentEncoder
{
    NSMutableDictionary *threadDictionary = [NSThread currentThread].threadDictionary;
    id encoder = threadDictionary[kCurrentEncoderKey];
    if (!encoder) {
        @synchronized(self) {
            encoder = threadDictionary[kCurrentEncoderKey];
            if (!encoder) {
                encoder = [[TyphoonInjectionPrimitiveEncoder alloc] init];
                threadDictionary[kCurrentEncoderKey] = encoder;
            }
        }
    }
    return encoder;
}

@end
