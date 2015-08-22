////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonOSXAppDelegate.h"
#import "iOSPlistConfiguredAssembly.h"
#import "Knight.h"

@implementation TyphoonOSXAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (NSUInteger)damselsRescued
{
    return [_assembly configuredCavalryMan].damselsRescued;
}


@end
