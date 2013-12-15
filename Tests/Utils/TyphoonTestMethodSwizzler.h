//
// Created by Robert Gilliam on 12/14/13.
//

#import <Foundation/Foundation.h>
#import "TyphoonMethodSwizzler.h"

@interface TyphoonTestMethodSwizzler : NSObject <TyphoonMethodSwizzler>

- (void)assertExchangedImplementationsFor:(NSString*)methodA with:(NSString*)methodB onClass:(Class)pClass;

@end