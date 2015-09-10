//
//  TyphoonFirstLoopAssembly.m
//  Typhoon
//
//  Created by Egor Tolstoy on 09/09/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import "TyphoonLoopedCollaboratingAssemblies.h"

@implementation TyphoonFirstLoopAssembly

- (id)testQuest {
    return [TyphoonDefinition withClass:[MediocreQuest class]];
}

@end

@implementation TyphoonSecondLoopAssembly
@end

@implementation TyphoonThirdLoopAssembly
@end

@implementation TyphoonFourthLoopAssembly

- (id)testQuest {
    return [TyphoonDefinition withClass:[MediocreQuest class]];
}

@end

@implementation TyphoonFifthLoopAssembly
@end