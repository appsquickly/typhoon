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

#import "TyphoonPreattachedComponentsRegisterer.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonAssembly+TyphoonAssemblyFriend.h"

@interface TyphoonPreattachedComponentsRegisterer ()

@property (strong, nonatomic) TyphoonComponentFactory *factory;

@end

@implementation TyphoonPreattachedComponentsRegisterer

- (instancetype)initWithComponentFactory:(TyphoonComponentFactory *)componentFactory {
    self = [super init];
    if (self) {
        _factory = componentFactory;
    }
    return self;
}

- (void)doRegistrationForAssembly:(TyphoonAssembly *)assembly {
    NSArray *infrastructureComponents = [assembly preattachedInfrastructureComponents];
    
    for (id component in infrastructureComponents) {
        if ([component conformsToProtocol:@protocol(TyphoonDefinitionPostProcessor)]) {
            [self.factory attachDefinitionPostProcessor:component];
        }
        else if ([component conformsToProtocol:@protocol(TyphoonInstancePostProcessor)]) {
            [self.factory attachInstancePostProcessor:component];
        }
        else if ([component conformsToProtocol:@protocol(TyphoonTypeConverter)]) {
            [self.factory attachTypeConverter:component];
        }
    }
}

@end
