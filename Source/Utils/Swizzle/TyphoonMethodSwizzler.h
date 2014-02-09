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



#import <Foundation/Foundation.h>

@protocol TyphoonMethodSwizzler <NSObject>

@required
- (BOOL)swizzleMethod:(SEL)selA withMethod:(SEL)selB onClass:(Class)pClass error:(NSError **)error;

@end