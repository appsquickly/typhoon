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


#import <Foundation/Foundation.h>
#import "TyphoonMethodSwizzler.h"

@class TyphoonAssembly;


@interface TyphoonAssemblyAdviser : NSObject

+ (BOOL)assemblyClassIsAdvised:(Class)class;

- (id)initWithAssembly:(TyphoonAssembly *)assembly;

- (void)adviseAssembly;

- (NSSet *)definitionSelectors;

@property(readonly, weak) TyphoonAssembly *assembly;
@property(nonatomic, strong) id <TyphoonMethodSwizzler> swizzler;

@end