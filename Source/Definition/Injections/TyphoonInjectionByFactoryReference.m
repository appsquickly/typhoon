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


#import "TyphoonInjectionByFactoryReference.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonCallStack.h"
#import "TyphoonStackElement.h"
#import "NSInvocation+TCFUnwrapValues.h"
#import "TyphoonUtils.h"

@implementation TyphoonInjectionByFactoryReference

- (instancetype)initWithReference:(NSString *)reference args:(TyphoonRuntimeArguments *)referenceArguments keyPath:(NSString *)keyPath
{
    self = [super initWithReference:reference args:referenceArguments];
    if (self) {
        _keyPath = keyPath;
    }
    return self;
}

#pragma mark - Overrides

- (id)copyWithZone:(NSZone *)zone
{
    TyphoonInjectionByFactoryReference *copied =
        [[TyphoonInjectionByFactoryReference alloc] initWithReference:self.reference args:self.referenceArguments keyPath:self.keyPath];
    [self copyBasePropertiesTo:copied];
    return copied;
}

- (BOOL)isEqualToCustom:(TyphoonInjectionByFactoryReference *)injection
{
    return  [super isEqualToCustom:injection] && [self.keyPath isEqualToString:injection.keyPath];
}

- (id)resolveReferenceWithContext:(TyphoonInjectionContext *)context
{
    id referenceInstance = [super resolveReferenceWithContext:context];
    
    return [referenceInstance valueForKeyPath:self.keyPath];
}

- (NSUInteger)customHash
{
    return TyphoonHashByAppendingInteger([super customHash], [self.keyPath hash]);
}

@end
