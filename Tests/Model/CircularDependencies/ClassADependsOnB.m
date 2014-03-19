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



#import "ClassADependsOnB.h"
#import "ClassBDependsOnA.h"


@implementation ClassADependsOnB
{
    ClassBDependsOnA *_dependencyOnB;
}

- (ClassBDependsOnA *)dependencyOnB
{
    return _dependencyOnB;
}

- (void)setDependencyOnB:(ClassBDependsOnA *)dependencyOnB
{
    _dependencyOnB = dependencyOnB;
}


@end