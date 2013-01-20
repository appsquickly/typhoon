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
#import "TyphoonComponentFactory.h"


@interface TyphoonXmlComponentFactory : TyphoonComponentFactory
{
    NSMutableArray* _resourceNames;
}

- (id)initWithConfigFileName:(NSString*)configFileName;

- (id)initWithConfigFileNames:(NSString*)configFileNames, ...NS_REQUIRES_NIL_TERMINATION;

@end