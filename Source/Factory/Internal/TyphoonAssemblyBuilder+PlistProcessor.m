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

#import "TyphoonAssemblyBuilder+PlistProcessor.h"
#import "TyphoonIntrospectionUtils.h"

@implementation TyphoonAssemblyBuilder (PlistProcessor)

+ (id)buildAssembliesFromPlistInBundle:(NSBundle *)bundle
{
    NSArray *assemblies = nil;
    NSArray *assemblyNames = [self plistAssemblyNames:bundle];
    NSAssert(!assemblyNames || [assemblyNames isKindOfClass:[NSArray class]],
             @"Value for 'TyphoonInitialAssemblies' key must be array");
    if ([assemblyNames count] > 0) {
        NSMutableArray *assemblyClasses = [[NSMutableArray alloc] initWithCapacity:[assemblyNames count]];
        for (NSString *assemblyName in assemblyNames) {
            Class assemblyClass = TyphoonClassFromString(assemblyName);
            if (!assemblyClass) {
                [NSException raise:NSInvalidArgumentException format:@"Can't resolve assembly for name %@",
                 assemblyName];
            }
            [assemblyClasses addObject:assemblyClass];
        }
        assemblies = [self buildAssembliesWithClasses:assemblyClasses];
    }
    return assemblies;
}

+ (NSArray *)plistAssemblyNames:(NSBundle *)bundle
{
    NSArray *names = nil;
    
    NSDictionary *bundleInfoDictionary = [bundle infoDictionary];
#if TARGET_OS_IPHONE
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        names = bundleInfoDictionary[@"TyphoonInitialAssemblies(iPad)"];
    } else {
        names = bundleInfoDictionary[@"TyphoonInitialAssemblies(iPhone)"];
    }
#endif
    if (!names) {
        names = bundleInfoDictionary[@"TyphoonInitialAssemblies"];
    }
    
    return names;
}

@end
