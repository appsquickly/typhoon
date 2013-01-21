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



#import "TyphoonDefinition+BlockAssembly.h"


@implementation TyphoonDefinition (BlockAssembly)

- (void)injectProperty:(SEL)selector withDefinition:(TyphoonDefinition*)definition
{
    [self injectProperty:selector withReference:definition.key];
}

@end