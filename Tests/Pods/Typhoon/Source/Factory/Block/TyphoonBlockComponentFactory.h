////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2013 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "TyphoonComponentFactory.h"

@class TyphoonAssembly;


@interface TyphoonBlockComponentFactory : TyphoonComponentFactory

+ (id)factoryWithAssembly:(TyphoonAssembly*)assembly;

- (id)initWithAssembly:(TyphoonAssembly*)assembly;

@end