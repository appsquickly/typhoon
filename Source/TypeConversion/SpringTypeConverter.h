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

@class SpringTypeDescriptor;

/**
* Declares a contract for converting configuration arguments to their required runtime type.
*/
@protocol SpringTypeConverter <NSObject>

- (id)convert:(NSString*)stringValue;

@end