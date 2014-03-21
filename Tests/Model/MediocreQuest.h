//
//  MediocreQuest.h
//  Tests
//
//  Created by Robert Gilliam on 3/20/14.
//
//

#import <Foundation/Foundation.h>
#import "Quest.h"

@interface MediocreQuest : NSObject <Quest>

@property (nonatomic, strong) NSURL *imageUrl;

@end
