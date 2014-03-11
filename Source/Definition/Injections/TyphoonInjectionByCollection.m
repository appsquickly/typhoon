//
//  TyphoonInjectionByCollection.m
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonInjectionByCollection.h"
#import "TyphoonCollectionValue.h"
#import "TyphoonInjectedAsCollection.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"

@interface TyphoonInjectionByCollection ()

@property (nonatomic, strong) TyphoonInjectedAsCollection *collection;

@end

@implementation TyphoonInjectionByCollection

- (instancetype)initWithRequiredType:(Class)requiredType
{
    self = [super init];
    if (self) {
        _requiredType = requiredType;
    }
    return self;
}

#pragma mark - <TyphoonInjectedAsCollection>

- (void)addItemWithText:(NSString *)text requiredType:(Class)requiredType
{
    [_collection addItemWithText:text requiredType:requiredType];
}

- (void)addItemWithComponentName:(NSString *)componentName
{
    [_collection addItemWithComponentName:componentName];
}

- (void)addItemWithDefinition:(TyphoonDefinition *)definition
{
    [_collection addItemWithDefinition:definition];
}

- (void)addValue:(id <TyphoonCollectionValue>)value
{
    [_collection addValue:value];
}

- (NSArray *)values
{
    return [_collection values];
}

#pragma mark - Instance methods

- (Class)collectionClassForPropertyInjectionOnInstance:(id<TyphoonIntrospectiveNSObject>)instance
{
    TyphoonTypeDescriptor *descriptor = [TyphoonIntrospectionUtils typeForPropertyWithName:self.propertyName inClass:[instance class]];
    Class describedClass = (Class) [descriptor classOrProtocol];
    if (describedClass == nil) {
        [NSException raise:NSInvalidArgumentException format:@"Property named '%@' does not exist on class '%@'.", self.propertyName,
         NSStringFromClass([instance class])];
    }
    return describedClass;
}

- (TyphoonCollectionType)resolveCollectionTypeWithClass:(Class)collectionClass;
{
    if ([collectionClass isSubclassOfClass:[NSMutableArray class]]) {
        return TyphoonCollectionTypeNSMutableArray;
    }
    else if ([collectionClass isSubclassOfClass:[NSArray class]]) {
        return TyphoonCollectionTypeNSArray;
    }
    else if ([collectionClass isSubclassOfClass:[NSCountedSet class]]) {
        return TyphoonCollectionTypeNSCountedSet;
    }
    else if ([collectionClass isSubclassOfClass:[NSMutableSet class]]) {
        return TyphoonCollectionTypeNSMutableSet;
    }
    else if ([collectionClass isSubclassOfClass:[NSSet class]]) {
        return TyphoonCollectionTypeNSSet;
    }
    return NSNotFound;
}

- (TyphoonCollectionType)collectionTypeForPropertyInjectionOnInstance:(id<TyphoonIntrospectiveNSObject>)instance
{
    Class collectionClass = [self collectionClassForPropertyInjectionOnInstance:instance];
    TyphoonCollectionType type = [self resolveCollectionTypeWithClass:collectionClass];
    if (type == NSNotFound) {
        [NSException raise:NSInvalidArgumentException format:@"Property named '%@' on '%@' is neither an NSSet nor NSArray.", self.propertyName,
         NSStringFromClass(collectionClass)];
    }
    return type;
}

- (TyphoonCollectionType)collectionTypeForParameterInjection
{
    if (!self.requiredType) {
        [NSException raise:NSInvalidArgumentException format:@"Required type is missing on injected collection parameter!"];
    }
    TyphoonCollectionType type = [self resolveCollectionTypeWithClass:self.requiredType];
    if (type == NSNotFound) {
        [NSException raise:NSInvalidArgumentException format:@"Required collection type '%@' is neither an NSSet nor NSArray.",
         NSStringFromClass(self.requiredType)];
    }
    return type;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByCollection *copied = [[TyphoonInjectionByCollection alloc] initWithRequiredType:self.requiredType];
    copied.collection = self.collection;
    [self copyBaseProperiesTo:copied];
    return copied;
}

- (id)valueToInjectPropertyOnInstance:(id)instance withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    TyphoonCollectionType type = [self collectionTypeForPropertyInjectionOnInstance:instance];
    return [_collection withFactory:factory newCollectionOfType:type];
}

- (void)setArgumentOnInvocation:(NSInvocation *)invocation withFactory:(TyphoonComponentFactory *)factory args:(TyphoonRuntimeArguments *)args
{
    id collection = [_collection withFactory:factory newCollectionOfType:[self collectionTypeForParameterInjection]];
    [invocation setArgument:&collection atIndex:self.parameterIndex + 2];
}


@end
