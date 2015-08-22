////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonAssemblyBuilder.h"
#import "TyphoonAssembly.h"

@implementation TyphoonAssemblyBuilder

+ (id)buildAssemblyWithClass:(Class)assemblyClass {
    return [[self buildAssembliesWithClasses:@[assemblyClass]] firstObject];
}

+ (id)buildAssembliesWithClasses:(NSArray *)assemblyClasses {
    if (assemblyClasses.count == 0) {
        return nil;
    }
    
    NSMutableArray *assemblies = [[NSMutableArray alloc] initWithCapacity:[assemblyClasses count]];
    for (Class assemblyClass in assemblyClasses) {
        if (!assemblyClass) {
            [NSException raise:NSInvalidArgumentException format:@"Can't resolve assembly for class %@",
             assemblyClass];
        }
        if (![assemblyClass isSubclassOfClass:[TyphoonAssembly class]]) {
            [NSException raise:NSInvalidArgumentException format:@"Class %@ is not a subclass of TyphoonAssembly",
             assemblyClass];
        }
        
        [assemblies addObject:[assemblyClass assembly]];
    }
    
    return [assemblies copy];
}

@end
