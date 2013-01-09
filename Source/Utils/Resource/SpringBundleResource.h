////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "SpringResource.h"

/**
* Represents a resource within the application bundle.
*/
@interface SpringBundleResource : NSObject<SpringResource>
{
    NSString* _stringValue;
}



+ (id<SpringResource>)withName:(NSString*)name;

- (id)initWithStringValue:(NSString*)stringValue;

@end
