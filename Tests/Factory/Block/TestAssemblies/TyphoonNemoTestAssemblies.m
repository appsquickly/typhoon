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


#import "TyphoonNemoTestAssemblies.h"



@implementation NemoCoreSecondViewController
@end

@implementation NemoCoreFirstViewController
@end

@implementation NemoCoreRootViewController
@end

@implementation NemoCoreNemoAssembly

- (TyphoonDefinition *)rootViewController {
    return [TyphoonDefinition withClass:[NemoCoreRootViewController class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (TyphoonDefinition *)firstViewController {
    return [TyphoonDefinition withClass:[NemoCoreFirstViewController class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (TyphoonDefinition *)secondViewController {
    return [TyphoonDefinition withClass:[NemoCoreSecondViewController class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end

@implementation NemoCoreSecondAssembly

- (TyphoonDefinition *)firstViewController {
    return [TyphoonDefinition withClass:[NemoCoreSecondViewController class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
    }];
}

@end