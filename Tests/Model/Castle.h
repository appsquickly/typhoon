//
//  Castle.h
//  Tests
//
//  Created by Robert Gilliam on 8/1/13.
//
//

#import <Foundation/Foundation.h>
#import "Moat.h"

@interface Castle : NSObject

- (id)initWithMoat:(Moat *)aMoat;

@property Moat *moat;

@end
