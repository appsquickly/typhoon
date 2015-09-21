//
//  TyphoonFirstLoopAssembly.h
//  Typhoon
//
//  Created by Egor Tolstoy on 09/09/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import <Typhoon/Typhoon.h>

#import "MediocreQuest.h"

@class TyphoonFirstLoopAssembly, TyphoonSecondLoopAssembly, TyphoonThirdLoopAssembly, TyphoonFourthLoopAssembly, TyphoonFifthLoopAssembly;

@interface TyphoonFirstLoopAssembly : TyphoonAssembly

@property (strong, nonatomic) TyphoonSecondLoopAssembly *secondAssembly;

- (id<Quest>)testQuest;

@end

@interface TyphoonSecondLoopAssembly : TyphoonAssembly

@property (strong, nonatomic) TyphoonThirdLoopAssembly *thirdAssembly;

@end

@interface TyphoonThirdLoopAssembly : TyphoonAssembly

@property (strong, nonatomic) TyphoonSecondLoopAssembly *secondAssembly;

@end

@interface TyphoonFourthLoopAssembly : TyphoonAssembly

@property (strong, nonatomic) TyphoonFifthLoopAssembly *fifthAssembly;

- (id<Quest>)testQuest;

@end

@interface TyphoonFifthLoopAssembly : TyphoonAssembly

@property (strong, nonatomic) TyphoonFourthLoopAssembly *fourthAssembly;

@end
