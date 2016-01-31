////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonBlockDefinition.h"

@interface TyphoonBlockDefinition ()

// This must be weak to prevent retain cycle between factory, definition and assembly.
@property (nonatomic, weak) id blockTarget;

@property (nonatomic, assign) SEL blockSelector;

@end
