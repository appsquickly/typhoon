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

#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"

@protocol ComponentFactoryAwareCollabortingAssemblyProtocol
- (id)anotherCollaboratingAssemblyObject;
@end

@interface AnotherComponentFactoryAwareCollabortingAssembly : TyphoonAssembly <ComponentFactoryAwareCollabortingAssemblyProtocol>

@end

@interface ComponentFactoryAwareCollabortingAssembly : TyphoonAssembly
- (id)collaboratingAssemblyObject;
@end

@interface ComponentFactoryAwareAssembly : TyphoonAssembly
@property (readonly) ComponentFactoryAwareCollabortingAssembly *collaboratingAssembly;
@property (readonly) TyphoonAssembly<ComponentFactoryAwareCollabortingAssemblyProtocol> *collaboratingAssembly2;

- (id)injectionAwareObject;

- (id)injectionFactoryByProperty;

- (id)injectionAssemblyByProperty;

- (id)injectionByInitialization;

- (id)injectionByPropertyAssemblyType;

- (id)injectionByPropertyFactoryType;

@end
