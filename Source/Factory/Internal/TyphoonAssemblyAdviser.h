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
#import "TyphoonMethodSwizzler.h"

@class TyphoonAssembly;


@interface TyphoonAssemblyAdviser : NSObject

+ (BOOL)assemblyClassIsAdvised:(Class)klass;

- (id)initWithAssembly:(TyphoonAssembly *)assembly;

- (void)adviseAssembly;

- (NSSet *)definitionSelectors;

- (NSDictionary *)assemblyClassPerDefinitionKey;

@property(readonly, weak) TyphoonAssembly *assembly;
@property(nonatomic, strong) id <TyphoonMethodSwizzler> swizzler;

@end
