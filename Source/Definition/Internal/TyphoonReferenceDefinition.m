////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonReferenceDefinition.h"
#import "TyphoonDefinition+Infrastructure.h"


@implementation TyphoonReferenceDefinition

+ (instancetype)definitionReferringToComponent:(NSString *)key
{
    return [[self alloc] initWithClass:[NSObject class] key:key];
}


@end
