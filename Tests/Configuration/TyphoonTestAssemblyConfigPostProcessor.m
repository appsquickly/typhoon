//
// Created by Aleksey Garbarev on 30.10.14.
// Copyright (c) 2014 typhoonframework.org. All rights reserved.
//

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