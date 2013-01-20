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
#import "TyphoonResource.h"

/**
* Represents a resource within the application bundle.
*/
@interface TyphoonBundleResource : NSObject <TyphoonResource>
{
    NSString* _stringValue;
}



+ (id<TyphoonResource>)withName:(NSString*)name;

- (id)initWithStringValue:(NSString*)stringValue;

@end
