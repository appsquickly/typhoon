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

#import "TyphoonStoryboardProvider.h"

#import "OCLogTemplate.h"

@implementation TyphoonStoryboardProvider

- (NSArray *)collectStoryboardsFromBundle:(NSBundle *)bundle {
    NSArray *storyboardPaths = [bundle pathsForResourcesOfType:@"storyboardc"
                                                   inDirectory:@""];
    
    NSMutableSet *mutableStoryboardNames = [NSMutableSet new];
    for (NSString *storyboardPath in storyboardPaths) {
        NSString *storyboardName = [[storyboardPath lastPathComponent] stringByDeletingPathExtension];
        [mutableStoryboardNames addObject:storyboardName];
    }
    NSSet *storyboardNames = [mutableStoryboardNames copy];
    
    storyboardNames = [self filterStoryboards:storyboardNames
                        withBlackListInBundle:bundle];
    
    return [storyboardNames allObjects];
}

- (NSSet *)filterStoryboards:(NSSet *)storyboardNames withBlackListInBundle:(NSBundle *)bundle {
    NSDictionary *bundleInfoDictionary = [bundle infoDictionary];
    NSSet *blackListedNames = [NSSet setWithArray:bundleInfoDictionary[@"TyphoonCleanStoryboards"]];
    
    for (NSString *blackListedName in blackListedNames) {
        if (![storyboardNames containsObject:blackListedName]) {
            LogInfo(@"*** Warning *** Can't find black-listed storyboard with name %@. Is this intentional?", blackListedName);
        }
    }
    
    NSMutableSet *filteredStoryboardNames = [storyboardNames mutableCopy];
    [filteredStoryboardNames minusSet:blackListedNames];
    
    return [filteredStoryboardNames copy];
}

@end
