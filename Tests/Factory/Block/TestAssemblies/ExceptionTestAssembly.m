////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "ExceptionTestAssembly.h"
#import "TyphoonDefinition.h"
#import "TyphoonInitializer.h"
#import "TyphoonShorthand.h"

@implementation ExceptionTestAssembly

- (id)anotherServiceUrl
{
    return [TyphoonDefinition withClass:[NSURL class] initialization:^(TyphoonInitializer *initializer) {
        initializer.selector = @selector(URLWithString:);
        [initializer injectParameter:@"string" with:InjectionWithObjectFromString(@"http://dev.foobar.com/service/")];
    }];
}

//- (id)aBlaString
//{
//    return [TyphoonDefinition withClass:[NSString class] initialization:^(TyphoonInitializer* initializer)
//    {
//        initializer.selector = @selector(stringWithBlaBla:);
//        [initializer injectParameterNamed:@"specification" withValueAsText:@"blue" requiredTypeOrNil:nil];
//    }];
//}


@end