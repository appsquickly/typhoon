////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>

@class SpringTypeDescriptor;

@protocol SpringTypeConverter <NSObject>

- (void*)convert:(NSString*)stringValue requiredType:(SpringTypeDescriptor*)typeDescriptor;

@end