//
//  MethonInjectinosAssembly.h
//  Tests
//
//  Created by Aleksey Garbarev on 27.03.14.
//
//

#import "TyphoonAssembly.h"

@interface MethodInjectinosAssembly : TyphoonAssembly

- (id)knightInjectedByMethod;
- (id)knightWithCircularDependency;
- (id)knightWithMethodRuntimeFoo:(NSString *)foo;
- (id)knightWithMethodFoo:(NSObject *)foo;
@end
