//
//  TyphoonFirstLoopAssembly.h
//  Typhoon
//
//  Created by Egor Tolstoy on 09/09/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import <Typhoon/Typhoon.h>
#import "TyphoonSecondLoopAssembly.h"

#import "MediocreQuest.h"

@interface TyphoonFirstLoopAssembly : TyphoonAssembly

@property (strong, nonatomic) TyphoonSecondLoopAssembly *secondAssembly;

- (id<Quest>)testQuest;

@end
