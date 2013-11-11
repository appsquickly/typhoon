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
#import "TyphoonResource.h"

/**
* Represents a resource within the application bundle.
*/
@interface TyphoonBundleResource : NSObject <TyphoonResource>
{
    NSData* _data;
}


+ (id <TyphoonResource>)withName:(NSString*)name;


@end
