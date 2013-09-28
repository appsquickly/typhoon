//
//  TyphoonStack.m
//  Typhoon
//
//  Created by Cesar Estebanez Tascon on 12/09/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import "TyphoonGenericStack.h"

@implementation TyphoonGenericStack
{
	NSMutableArray *_storage;
}


#pragma mark Initialization

+ (instancetype)stack
{
	return [[self alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        _storage = [NSMutableArray array];
    }
    return self;
}


#pragma mark Public API

- (void)push:(id)element
{
	[_storage addObject:element];
}

- (id)pop
{
	id element = [_storage lastObject];
    if ([self isEmpty] == NO)
    {
        [_storage removeLastObject];
    }
	return element;
}

- (id)peek
{
	return [_storage lastObject];
}

- (BOOL)isEmpty
{
	return ([_storage count] == 0);
}

@end
