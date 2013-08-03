//
//  Township.h
//  Tests
//
//  Created by Robert Gilliam on 8/3/13.
//
//

#import <Foundation/Foundation.h>
#import "Knight.h"
#import "Moat.h"

@interface Township : NSObject

- (id)initWithSheriff:(Knight *)theSheriff moat:(Moat *)theMoat;

@property (readonly) Knight *sheriff;
@property (readonly) Moat *moat;

@end

