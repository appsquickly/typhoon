//
// Created by Robert Gilliam on 11/5/13.
//


#import "DefinitionInheritanceAssembly.h"
#import "TyphoonDefinition.h"
#import "CampaignQuest.h"
#import "TyphoonInitializer.h"
#import "Knight.h"
#import "ErrandQuest.h"
#import "Widget.h"
#import "TyphoonInitializer+InstanceBuilder.h"


@implementation DefinitionInheritanceAssembly {

}

- (id)knightWithNoDependenciesButInitializer
{
    return [TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer) {
//         initializer.selector = @selector(init);
    }];
}

- (id)knightWithNoDependencies
{
    return [TyphoonDefinition withClass:[Knight class]];
}

- (id)knightWithConstructorDependency
{
    return [TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer) {
        initializer.selector = @selector(initWithQuest:);

        [initializer injectWithDefinition:[self campaignQuest]];
    }];
}

- (id)childKnightWithNoDependenciesButInitializer
{
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        definition.parent = [self knightWithNoDependenciesButInitializer];
    }];
}

- (id)childKnightWithNoDependencies
{
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        definition.parent = [self knightWithNoDependencies];
    }];
}

- (id)childKnightWithConstructorDependency
{
    // no initializer, yet we need to use the parents initializer.
    return [TyphoonDefinition withClass:[Knight class] properties:^(TyphoonDefinition* definition)
    {
        definition.parent = [self knightWithConstructorDependency];
    }];
}

- (id)campaignQuest
{
    return [TyphoonDefinition withClass:[CampaignQuest class] initialization:nil];
}

- (id)errandQuest
{
    return [TyphoonDefinition withClass:[ErrandQuest class] initialization:nil];
}



// different from what it is right now, none with a dependency added
- (id)childKnightWithOverridenConstructorDependency
{
    // a specified initializer will completely override.
    // because of position dependent calls to injectWithDefinition.
    return [TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:);

        [initializer injectWithDefinition:[self campaignQuest]];
    } properties:^(TyphoonDefinition* definition)
    {
        definition.parent = [self knightOnErrandQuest];
    }];
}

- (TyphoonDefinition*)knightOnErrandQuest
{
    return [TyphoonDefinition withClass:[Knight class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithQuest:);

        [initializer injectWithDefinition:[self errandQuest]];
    }];
}

- (id)childWidgetWithDependencyOnCInheritingFromAandB
{
    return [TyphoonDefinition withClass:[Widget class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithWidgetC:);

        [initializer injectWithDefinition:[self widgetC]];
    } properties:^(TyphoonDefinition* definition)
    {
        definition.parent = [self widgetDependingOnAandB];
    }];
}

- (id)widgetC
{
    return [TyphoonDefinition withClass:[Widget class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithName:);

        [initializer injectWithValueAsText:@"C" requiredTypeOrNil:[NSString class]];
    }];
}

- (id)widgetB
{
    return [TyphoonDefinition withClass:[Widget class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithName:);

        [initializer injectWithValueAsText:@"B" requiredTypeOrNil:[NSString class]];
    }];
}

- (id)widgetA
{
    return [TyphoonDefinition withClass:[Widget class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithName:);

        [initializer injectWithValueAsText:@"A" requiredTypeOrNil:[NSString class]];
    }];
}

- (id)widgetDependingOnAandB
{
    return [TyphoonDefinition withClass:[Widget class] initialization:^(TyphoonInitializer* initializer)
    {
        initializer.selector = @selector(initWithWidgetA:widgetB:);

        [initializer injectWithDefinition:[self widgetA]];
        [initializer injectWithDefinition:[self widgetB]];
    }];
}

@end