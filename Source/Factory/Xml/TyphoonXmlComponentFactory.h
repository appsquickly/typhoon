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
#import "TyphoonComponentFactory.h"

/**
* @ingroup Factory
*/
@interface TyphoonXmlComponentFactory : TyphoonComponentFactory
{
    NSMutableArray *_resourceNames;
}

- (id)initWithConfigFileName:(NSString *)configFileName;

- (id)initWithConfigFileNames:(NSString *)configFileNames, ...NS_REQUIRES_NIL_TERMINATION;

@end
