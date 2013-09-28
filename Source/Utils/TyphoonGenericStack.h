//
//  TyphoonStack.h
//  Typhoon
//
//  Created by Cesar Estebanez Tascon on 12/09/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//
//
//  This class implements a not thread-safe generic stack
//

#import <Foundation/Foundation.h>

@interface TyphoonGenericStack : NSObject

+ (instancetype)stack;

- (void)push:(id)element;

- (id)pop;

- (id)peek;

- (BOOL)isEmpty;

@end
