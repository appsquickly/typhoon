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



#import "ClassBDependsOnA.h"
#import "ClassADependsOnB.h"


@implementation ClassBDependsOnA
{
    ClassADependsOnB *_dependencyOnA;
}

- (ClassADependsOnB *)dependencyOnA
{
    return _dependencyOnA;
}

- (void)setDependencyOnA:(ClassADependsOnB *)dependencyOnA
{
    _dependencyOnA = dependencyOnA;
}


@end