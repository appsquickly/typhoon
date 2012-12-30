////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "SpringComponentFactory.h"


@interface SpringXmlComponentFactory : SpringComponentFactory
{
    NSMutableArray* _resourceNames;
}

- (id)initWithConfigFileName:(NSString*)configFileName;

- (id)initWithConfigFileNames:(NSString*)configFileNames, ...NS_REQUIRES_NIL_TERMINATION;

@end