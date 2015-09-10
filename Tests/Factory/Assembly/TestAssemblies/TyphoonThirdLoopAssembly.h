//
//  TyphoonThirdLoopAssembly.h
//  Typhoon
//
//  Created by Egor Tolstoy on 09/09/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import <Typhoon/Typhoon.h>
#import "TyphoonFirstLoopAssembly.h"
#import "TyphoonSecondLoopAssembly.h"

@interface TyphoonThirdLoopAssembly : TyphoonAssembly

@property (strong, nonatomic) TyphoonSecondLoopAssembly *secondAssembly;

@end
