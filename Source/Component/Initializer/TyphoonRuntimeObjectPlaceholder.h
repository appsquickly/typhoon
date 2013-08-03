//
//  TyphoonRuntimeObjectPlaceholder.h
//  Static Library
//
//  Created by Robert Gilliam on 8/3/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TyphoonRuntimeObjectPlaceholder : NSObject

- (id)initWithIndexInArguments:(NSUInteger)theIndex;

@property (readonly) NSUInteger indexInArguments;

@end
