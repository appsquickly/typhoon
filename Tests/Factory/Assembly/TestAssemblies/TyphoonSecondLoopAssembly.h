//
//  TyphoonSecondLoopAssembly.h
//  Typhoon
//
//  Created by Egor Tolstoy on 09/09/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import <Typhoon/Typhoon.h>

@class TyphoonThirdLoopAssembly;

@interface TyphoonSecondLoopAssembly : TyphoonAssembly

@property (strong, nonatomic) TyphoonThirdLoopAssembly *thirdAssembly;

@end
