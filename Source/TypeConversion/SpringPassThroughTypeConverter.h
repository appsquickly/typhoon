////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2012 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "SpringTypeConverter.h"

/**
* A 'type converter' for NSString and NSMutableString.
*/
@interface SpringPassThroughTypeConverter : NSObject<SpringTypeConverter>

@property (nonatomic, readonly) BOOL isMutable;

- (id)initWithIsMutable:(BOOL)isMutable;

@end