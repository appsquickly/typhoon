//
//  TyphoonInvocation.h
//  Pods
//
//  Created by Aleksey Garbarev on 30.01.14.
//
//

#import <Foundation/Foundation.h>

@interface NSInvocation (TyphoonInvocation)

- (id) resultOfInvokingOnInstance:(id)instance NS_RETURNS_RETAINED;

- (id) resultOfInvokingOnAllocationForClass:(Class)aClass NS_RETURNS_RETAINED;

@end
