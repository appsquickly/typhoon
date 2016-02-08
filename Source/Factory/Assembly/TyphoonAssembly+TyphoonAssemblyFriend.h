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


#import "TyphoonAssembly.h"

@interface TyphoonAssembly (TyphoonAssemblyFriend)

+ (BOOL)selectorIsReserved:(SEL)selector;

- (void)prepareForUse;

- (NSArray *)definitions;

- (NSArray *)preattachedInfrastructureComponents;

- (Class)assemblyClassForKey:(NSString *)key;

- (void)activateWithFactory:(TyphoonComponentFactory *)factory collaborators:(NSSet *)collaborators;

@property (readonly) NSSet *definitionSelectors;

@end
