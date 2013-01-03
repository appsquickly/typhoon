////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////





#import <Foundation/Foundation.h>

@class SpringComponentDefinition;

/**
* This is the base class for for all spring component factories. Although, it could be used as-is, the intention is to use a
* sub-class like SpringXmlComponentFactory.
*/
@interface SpringComponentFactory : NSObject
{
    NSMutableArray* _registry;
    NSMutableDictionary* _singletons;

    NSMutableSet* _currentlyResolvingReferences;
}

/**
* Returns the default component factory, if one has been set. (See makeDefault ).
*/
+ (SpringComponentFactory*)defaultFactory;

/**
* Sets a given instance of SpringComponentFactory, as the default factory so that it can be retrieved later with:

    [SpringComponentFactory defaultFactory];

*/
- (void)makeDefault;

- (void) register:(SpringComponentDefinition*)definition;

- (id)componentForType:(id)classOrProtocol;

 - (NSArray*)allComponentsForType:(id)classOrProtocol;

- (id)componentForKey:(NSString*)key;



@end