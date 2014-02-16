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



#import "TyphoonJRMethodSwizzler.h"
#import "TyphoonJRSwizzle.h"


@implementation TyphoonJRMethodSwizzler
{

}

- (BOOL)swizzleMethod:(SEL)selA withMethod:(SEL)selB onClass:(Class)pClass error:(NSError **)error
{
    return [pClass typhoon_swizzleMethod:selA withMethod:selB error:error];
}

@end