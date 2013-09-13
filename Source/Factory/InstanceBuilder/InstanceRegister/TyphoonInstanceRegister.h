//
//  TyphoonInstanceRegister.h
//  Typhoon
//
//  Created by Cesar Estebanez Tascon on 12/09/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TyphoonInstanceRegister <NSObject>

+ (instancetype)instanceRegister;

- (void)stashInstance:(id)instance forKey:(NSString *)key;

- (id)unstashInstanceForKey:(NSString *)key;

- (id)peekInstanceForKey:(NSString *)key;

- (BOOL)hasInstanceForKey:(NSString *)key;

@end
