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


#import "TyphoonDefinition+Option.h"
#import "TyphoonOptionMatcher+Internal.h"
#import "TyphoonInjections.h"
#import "TyphoonFactoryDefinition.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonRuntimeArguments.h"
#import "TyphoonInjectionContext.h"
#import "TyphoonInjection.h"
#import "TyphoonDefinition+Infrastructure.h"
#import "TyphoonDefinition+InstanceBuilder.h"

@interface TyphoonOptionDefinition : TyphoonFactoryDefinition <TyphoonAutoInjectionConfig>

@property(nonatomic, strong) id <TyphoonInjection> optionInjection;
@property(nonatomic, strong) TyphoonOptionMatcher* matcher;

@end

@implementation TyphoonOptionDefinition

- (instancetype)initWithOptionValue:(id)value matcher:(TyphoonOptionMatcher*)matcher
{
    self = [super initWithClass:[NSObject class] key:nil];
    if (self)
    {
        self.optionInjection = TyphoonMakeInjectionFromObjectIfNeeded(value);
        self.matcher = matcher;
        self.scope = TyphoonScopePrototype;
    }
    return self;
}

- (id)targetForInitializerWithFactory:(TyphoonComponentFactory*)factory args:(TyphoonRuntimeArguments*)args
{
    TyphoonInjectionContext* context = [[TyphoonInjectionContext alloc] initWithFactory:factory args:args raiseExceptionIfCircular:YES];
    context.destinationType = [TyphoonTypeDescriptor descriptorWithEncodedType:@encode(id)];

    __block id optionValue = nil;
    [self.optionInjection valueToInjectWithContext:context completion:^(id value) {
        optionValue = value;
    }];

    id <TyphoonInjection> injection = [self.matcher injectionMatchedValue:optionValue];

    __block id result = nil;
    [injection valueToInjectWithContext:context completion:^(id value) {
        result = value;
    }];

    return result;
}

- (TyphoonMethod*)initializer
{
    return nil;
}

- (void)enumerateInjectionsOfKind:(Class)injectionClass options:(TyphoonInjectionsEnumerationOption)options
    usingBlock:(TyphoonInjectionsEnumerationBlock)block
{
    if (options & TyphoonInjectionsEnumerationOptionProperties)
    {
        if ([self.optionInjection isKindOfClass:injectionClass])
        {
            id injectionToReplace = nil;
            BOOL stop = NO;
            block(self.optionInjection, &injectionToReplace, &stop);
            if (injectionToReplace)
            {
                self.optionInjection = injectionToReplace;
            }
            if (stop)
            {
                return;
            }
        }
    }

    [super enumerateInjectionsOfKind:injectionClass options:options usingBlock:block];
}


@end

@implementation TyphoonDefinition (Option)

+ (id)withOption:(id)option yes:(id)yesDefinition no:(id)noDefinition
{
    return [self withOption:option matcher:^(TyphoonOptionMatcher* matcher) {
        [matcher caseEqual:@YES use:yesDefinition];
        [matcher caseEqual:@"YES" use:yesDefinition];
        [matcher caseEqual:@"1" use:yesDefinition];
        [matcher caseEqual:@NO use:noDefinition];
        [matcher caseEqual:@"NO" use:noDefinition];
        [matcher caseEqual:@"0" use:noDefinition];
    }];
}

+ (id)withOption:(id)option matcher:(TyphoonMatcherBlock)matcherBlock
{
    TyphoonOptionMatcher* matcher = [[TyphoonOptionMatcher alloc] initWithBlock:matcherBlock];

    return [[TyphoonOptionDefinition alloc] initWithOptionValue:option matcher:matcher];
}

+ (id)withOption:(id)option matcher:(TyphoonMatcherBlock)matcherBlock
    autoInjectionConfig:(void (^)(id <TyphoonAutoInjectionConfig> config))configBlock
{
    TyphoonOptionMatcher* matcher = [[TyphoonOptionMatcher alloc] initWithBlock:matcherBlock];

    TyphoonOptionDefinition* definition = [[TyphoonOptionDefinition alloc] initWithOptionValue:option matcher:matcher];

    if (configBlock)
    {
        configBlock(definition);
    }

    return definition;
}


@end



