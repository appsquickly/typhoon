////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2012 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>

@class SpringComponentDefinition;


@interface SpringComponentFactory : NSObject
{
    NSMutableArray* _registry;
    NSMutableDictionary* _singletons;
}

- (void) register:(SpringComponentDefinition*)definition;

- (id) objectForType:(id)classOrProtocol;

 - (NSArray*)allObjectsForType:(id)classOrProtocol;

- (id) objectForKey:(NSString*)key;

@end