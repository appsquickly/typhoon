//
// Created by Aleksey Garbarev on 04.06.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

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