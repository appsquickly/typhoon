//
//  TyphoonRuntimeArguments.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 10.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TyphoonRuntimeArguments : NSObject <NSCopying>

+ (instancetype)argumentsFromInvocation:(NSInvocation *)invocation;

- (id)argumentValueAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfArgumentWithKind:(Class)clazz;

/** RuntimeArguments - arguments passed by user at runtime
*   ReferenceArguments - arguments specified in the assembly class
*
*   for example we have definition in the assembly
*
*   - (Person *)personWithFirstName:(NSString *)firstName lastName:(NSString *)lastName
*   {
*       return [TyphoonDefinition withClass:[Person class] configuration:^(TyphoonDefinition *definition) {
*           [definition injectProperty:@selector(firstName) with:firstName];
*           [definition injectProperty:@selector(lastName) with:lastName];
*       }];
*   }
*   Reference argument here is :
*   0 - TyphoonInjectionByRuntimeArgument at index 0
*   1 - TyphoonInjectionByRuntimeArgument at index 1
*
*   Runtime argument is:
*   0 - (NSString *) John
*   1 - (NSString *) Smith
*
*   This method return ReferenceArguments, but with replaced TyphoonInjectionByRuntimeArgument with runtime values
*   0 - TyphoonInjectionByRuntimeArgument at index 0 will be replaced by (NSString *)John
*   1 - TyphoonInjectionByRuntimeArgument at index 1 will be replaced by (NSString *)Smith
*   */
+ (TyphoonRuntimeArguments *)argumentsFromRuntimeArguments:(TyphoonRuntimeArguments *)runtimeArguments appliedToReferenceArguments:(TyphoonRuntimeArguments *)referenceArguments;

@end
