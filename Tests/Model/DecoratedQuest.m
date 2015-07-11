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

#import "DecoratedQuest.h"

@interface DecoratedQuest ()

@property (strong, nonatomic) NSObject <Quest> *quest;

@end

@implementation DecoratedQuest

- (instancetype)initWithQuest:(id <Quest>)quest {
    self.quest = quest;
    return self;
}

+ (instancetype)decoratedQuestWith:(id <Quest>)quest {
    return [[[self class] alloc] initWithQuest:quest];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.quest methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.quest];
}

- (NSString *)questName {
    NSString *originalQuestName = [self.quest questName];
    NSString *decoratedQuestName = [NSString stringWithFormat:@"%@_decorated", originalQuestName];
    
    return decoratedQuestName;
}

@end
