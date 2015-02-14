//
// Created by Robert Gilliam on 1/9/14.
//

#import <Foundation/Foundation.h>
#import "TyphoonAssembly.h"


@interface AssemblyWithProperty : TyphoonAssembly

@property TyphoonAssembly *assembly;

@property NSString *name;

@end