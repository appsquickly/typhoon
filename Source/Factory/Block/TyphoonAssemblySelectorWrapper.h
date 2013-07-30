//
//  AssemblyMethodSelectorToKeyConverter.h
//  Static Library
//
//  Created by Robert Gilliam on 7/29/13.
//  Copyright (c) 2013 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TyphoonAssemblySelectorWrapper : NSObject

+ (SEL)wrappedSELForKey:(NSString *)key;
+ (NSString *)keyForWrappedSEL:(SEL)selWithAdvicePrefix;
+ (BOOL)selectorIsWrapped:(SEL)sel;

+ (SEL)wrappedSELForSEL:(SEL)unwrappedSEL;

@end
