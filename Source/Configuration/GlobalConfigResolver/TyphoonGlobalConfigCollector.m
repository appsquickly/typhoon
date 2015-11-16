////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonGlobalConfigCollector.h"

@interface TyphoonGlobalConfigCollector ()

@property (strong, nonatomic) id appDelegate;

@end

@implementation TyphoonGlobalConfigCollector

- (instancetype)initWithAppDelegate:(id)appDelegate {
    self = [super init];
    if (self) {
        _appDelegate = appDelegate;
    }
    return self;
}

- (NSArray *)obtainGlobalConfigFilenamesFromBundle:(NSBundle *)bundle {
    NSArray *plistFilenames = [self fetchConfigFilenamesFromPlistKeyInBundle:bundle];
    NSArray *appDelegateFilenames = [self fetchConfigFilenamesFromAppDelegate];
    NSString *bundleIdFilename = [self fetchConfigFilenameFromUniqueBundleIdInBundle:bundle];
    NSString *oldStylePlistFilename = [self fetchConfigFilenameFromOldStylePlistKeyInBundle:bundle];
    
    NSMutableSet *resultNames = [NSMutableSet set];
    if (plistFilenames) {
        [resultNames addObjectsFromArray:plistFilenames];
    }
    
    if (appDelegateFilenames) {
        [resultNames addObjectsFromArray:appDelegateFilenames];
    }
    
    if (bundleIdFilename) {
        [resultNames addObject:bundleIdFilename];
    }
    
    if (oldStylePlistFilename) {
        [resultNames addObject:oldStylePlistFilename];
    }
    
    return [resultNames allObjects];
}

- (NSArray *)fetchConfigFilenamesFromPlistKeyInBundle:(NSBundle *)bundle {
    NSArray *fileNames = [bundle infoDictionary][@"TyphoonGlobalConfigFilenames"];
    return fileNames;
}

- (NSArray *)fetchConfigFilenamesFromAppDelegate {
    NSArray *fileNames;
    SEL globalConfigFilenamesSelector = NSSelectorFromString(@"globalConfigFilenames");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self.appDelegate respondsToSelector:globalConfigFilenamesSelector]) {
        fileNames = [self.appDelegate performSelector:globalConfigFilenamesSelector];
    }
#pragma clang diagnostic pop
    return fileNames;
}

- (NSString *)fetchConfigFilenameFromOldStylePlistKeyInBundle:(NSBundle *)bundle {
    NSString *configFileName = [bundle infoDictionary][@"TyphoonConfigFilename"];
    return configFileName;
}

- (NSString *)fetchConfigFilenameFromUniqueBundleIdInBundle:(NSBundle *)bundle {
    NSString *fileName = nil;
    
    NSString *bundleID = [bundle infoDictionary][@"CFBundleIdentifier"];
    NSString *configFilename = [NSString stringWithFormat:@"config_%@.plist", bundleID];
    NSString *configPath = [[bundle resourcePath] stringByAppendingPathComponent:configFilename];
    if ([[NSFileManager defaultManager] fileExistsAtPath:configPath]) {
        fileName = configFilename;
    }
    
    return fileName;
}

@end
