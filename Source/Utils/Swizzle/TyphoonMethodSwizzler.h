//
// Created by Robert Gilliam on 12/14/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TyphoonMethodSwizzler <NSObject>

@required
- (BOOL)swizzleMethod:(SEL)selA withMethod:(SEL)selB onClass:(Class)pClass error:(NSError**)error;

@end