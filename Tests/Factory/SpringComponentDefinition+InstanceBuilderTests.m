////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <SenTestingKit/SenTestingKit.h>
#import <objc/runtime.h>
#import "SpringComponentDefinition.h"
#import "SpringComponentFactory.h"
#import "SpringComponentInitializer.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "SpringComponentFactory+InstanceBuilder.h"


@interface ComponentDefinition_InstanceBuilderTests : SenTestCase
@end

@implementation ComponentDefinition_InstanceBuilderTests
{
    SpringComponentFactory* _componentFactory;
}

- (void)setUp
{
    _componentFactory = [[SpringComponentFactory alloc] init];
}

- (void)test_injects_required_initializer_dependencies
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    SpringComponentInitializer* knightInitializer = [[SpringComponentInitializer alloc] initWithSelector:@selector(initWithQuest:)];
    [knightInitializer injectParameterNamed:@"quest" withReference:@"quest"];
    [knightDefinition setInitializer:knightInitializer];
    [_componentFactory register:knightDefinition];

    SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    LogDebug(@"Here's the knight: %@", knight);
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_injects_required_initializer_dependencies_with_factory_method
{
    SpringComponentDefinition* bundleDefinition = [[SpringComponentDefinition alloc] initWithClazz:[NSBundle class] key:@"bundle"];
    [bundleDefinition setInitializer:[[SpringComponentInitializer alloc] initWithSelector:@selector(mainBundle) isFactoryMethod:YES]];
    [_componentFactory register:bundleDefinition];

    NSBundle* bundle = [_componentFactory buildInstanceWithDefinition:bundleDefinition];
    LogDebug(@"Here's the bundle: %@", bundle);
    assertThat(bundle, notNilValue());
}

- (void)test_injects_required_property_dependencies
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"quest" withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
    LogDebug(@"Here's the knight: %@", knight);
    assertThat(knight, notNilValue());
    assertThat(knight.quest, notNilValue());
}

- (void)test_raises_exception_if_property_setter_does_not_exist
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"propertyThatDoesNotExist" withReference:@"quest"];
    [_componentFactory register:knightDefinition];

    SpringComponentDefinition* questDefinition = [[SpringComponentDefinition alloc] initWithClazz:[CampaignQuest class] key:@"quest"];
    [_componentFactory register:questDefinition];

    @try
    {
        Knight* knight = [_componentFactory buildInstanceWithDefinition:knightDefinition];
        LogDebug(@"Here's the knight: %@", knight);
        STFail(@"Should have thrown exception");
    }
    @catch (NSException* e)
    {
        assertThat([e description], equalTo(
            @"Tried to inject property 'propertyThatDoesNotExist' on object of type 'Knight', but the instance has no setter for this property."));
    }
}

- (void)test_injects_property_value_as_long
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    [knightDefinition injectProperty:@"damselsRescued" withValueAsText:@"12"];
    [_componentFactory register:knightDefinition];

    Knight* knight = [_componentFactory objectForKey:@"knight"];
    assertThatLong(knight.damselsRescued, equalToLongLong(12));
}

- (void)test_injects_initializer_value_as_long
{
    SpringComponentDefinition* knightDefinition = [[SpringComponentDefinition alloc] initWithClazz:[Knight class] key:@"knight"];
    SpringComponentInitializer* initializer =
            [[SpringComponentInitializer alloc] initWithSelector:@selector(initWithQuest:damselsRescued:) isFactoryMethod:NO];
    [initializer injectParameterNamed:@"damselsRescued" withValueAsText:@"12" requiredTypeOrNil:nil];
    [knightDefinition setInitializer:initializer];

    [_componentFactory register:knightDefinition];

    Knight* knight = [_componentFactory objectForKey:@"knight"];
    assertThatLong(knight.damselsRescued, equalToLongLong(12));
}

- (void)test_ivar_reflection
{
    unsigned int ivarCount = 0;
    Ivar* ivars = class_copyIvarList([Knight class], &ivarCount);

    for (unsigned int x = 0; x < ivarCount; x++)
    {
        NSLog(@"Name [%@] encoding [%@]", [NSString stringWithCString:ivar_getName(ivars[x]) encoding:NSUTF8StringEncoding],
                [NSString stringWithCString:ivar_getTypeEncoding(ivars[x]) encoding:NSUTF8StringEncoding]);
    }

}

- (void)test_is_kind_of_class
{
    BOOL kind = [[CampaignQuest class] conformsToProtocol:@protocol(NSTableViewDataSource)];
    LogDebug(@"Is kind of class? %@", kind == YES ? @"YES" : @"NO");
}

@end
