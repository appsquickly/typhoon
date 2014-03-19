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

#import <SenTestingKit/SenTestingKit.h>
#import <TyphoonViewControllerNibResolver.h>
#import <UIKit/UIKit.h>
#import <TyphoonDefinition.h>
#import <TyphoonDefinition+InstanceBuilder.h>
#import <TyphoonComponentFactory.h>
#import <TyphoonMethod.h>
#import <TyphoonMethod+InstanceBuilder.h>

@interface TyphoonViewControllerNibResolverTests : SenTestCase
{
    TyphoonViewControllerNibResolver *_nibResolver;
}

@end

@implementation TyphoonViewControllerNibResolverTests

- (void)setUp
{
    [super setUp];
    _nibResolver = [[TyphoonViewControllerNibResolver alloc] init];
}

- (void)test_process_view_controller_without_initializer
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[UIViewController class]];
    TyphoonComponentFactory *factory = mock([TyphoonComponentFactory class]);
    [given([factory registry]) willReturn:@[definition]];

    [_nibResolver postProcessComponentFactory:factory];

    assertThat(definition.initializer, notNilValue());
    assertThat(NSStringFromSelector(definition.initializer.selector), equalTo(NSStringFromSelector(@selector(initWithNibName:bundle:))));
    assertThatUnsignedInteger([[definition.initializer injectedParameters] count], equalToUnsignedInteger(2));

}

- (void)test_skips_view_controller_with_initializer
{
    TyphoonDefinition *definition = [TyphoonDefinition withClass:[UIViewController class]];
    TyphoonMethod *initializer = [[TyphoonMethod alloc] initWithSelector:@selector(initWithFoobar:)];
    definition.initializer = initializer;

    TyphoonComponentFactory *factory = mock([TyphoonComponentFactory class]);
    [given([factory registry]) willReturn:@[definition]];

    [_nibResolver postProcessComponentFactory:factory];
    assertThat(NSStringFromSelector(initializer.selector), equalTo(NSStringFromSelector(@selector(initWithFoobar:))));
    assertThat(definition.initializer, equalTo(initializer));
}


- (void)test_resolves_nib_name_from_class
{
    Class clazz = [UIViewController class];
    NSString *nibName = [_nibResolver resolveNibNameForClass:clazz];
    assertThat(nibName, equalTo(NSStringFromClass(clazz)));
}

@end
