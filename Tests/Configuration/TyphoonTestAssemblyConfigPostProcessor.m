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

#import "TyphoonTestAssemblyConfigPostProcessor.h"
#import "Knight.h"
#import "CampaignQuest.h"
#import "TyphoonConfigPostProcessor.h"


@implementation TyphoonTestAssemblyConfigPostProcessor
{

}
- (Knight *)knight
{
    return [TyphoonDefinition withClass:[Knight class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(quest) with:[self questWithUrl:TyphoonConfig(@"json.quest_url")]];
    }];
}

- (id<Quest>)questWithUrl:(NSURL *)url
{
    return [TyphoonDefinition withClass:[CampaignQuest class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(imageUrl) with:url];
    }];
}

@end