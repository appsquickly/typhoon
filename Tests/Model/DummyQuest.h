//
//  DummyQuest.h
//  Typhoon-iOS
//
//  Created by Aleksey Garbarev on 14/09/2017.
//  Copyright © 2017 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quest.h"

@interface DummyQuest : NSObject  <Quest>

@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, weak) id context;

@end
