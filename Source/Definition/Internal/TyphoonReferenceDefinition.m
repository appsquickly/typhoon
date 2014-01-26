////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2014 ibipit
//  All Rights Reserved.
//
//  NOTICE: This software is the proprietary information of ibipit
//  Use is subject to license terms.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonReferenceDefinition.h"
#import "TyphoonDefinition+Infrastructure.h"


@implementation TyphoonReferenceDefinition

+ (instancetype)definitionReferringToComponent:(NSString*)key
{
    return [super withClass:[NSObject class] key:key];
}


@end