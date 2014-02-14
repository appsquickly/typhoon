////////////////////////////////////////////////////////////////////////////////
//
//  INFRAXIS
//  Copyright 2013 Infraxis
//  All Rights Reserved.
//
//  NOTICE: Infraxis permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>


@interface ClassWithCollectionProperties : NSObject

@property(nonatomic, strong) NSArray *arrayCollection;
@property(nonatomic, strong) NSMutableArray *mutableArrayCollection;
@property(nonatomic, strong) NSSet *setCollection;
@property(nonatomic, strong) NSMutableSet *mutableSetCollection;
@property(nonatomic, strong) NSString *notACollection;


@end