//
// Created by Robert Gilliam on 12/14/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonJRMethodSwizzler.h"
#import "TyphoonJRSwizzle.h"


@implementation TyphoonJRMethodSwizzler
{

}

- (BOOL)swizzleMethod:(SEL)selA withMethod:(SEL)selB onClass:(Class)pClass error:(NSError**)error
{
    return [pClass typhoon_swizzleMethod:selA withMethod:selB error:error];
}

@end