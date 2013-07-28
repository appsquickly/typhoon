////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"
#import "ClassADependsOnB.h"
#import "ClassBDependsOnA.h"
#import "ClassCDependsOnDAndE.h"
#import "ClassDDependsOnC.h"
#import "ClassEDependsOnC.h"
#import "UnsatisfiableClassFDependsOnGInInitializer.h"
#import "UnsatisfiableClassGDependsOnFInInitializer.h"

@interface CircularDependenciesAssembly : TyphoonAssembly

- (id)classA;
- (id)classB;

- (id)unsatisfiableClassFWithCircularDependencyInInitializer;
- (id)unsatisfiableClassGWithCircularDependencyInInitializer;

@end