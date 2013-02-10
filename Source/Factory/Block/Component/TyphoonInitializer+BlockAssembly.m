////////////////////////////////////////////////////////////////////////////////
//
//  AppsQuick.ly
//  Copyright 2013 AppsQuick.ly
//  All Rights Reserved.
//
//  NOTICE: AppsQuick.ly permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonInitializer+BlockAssembly.h"
#import "TyphoonDefinition+BlockAssembly.h"


@implementation TyphoonInitializer (BlockAssembly)

- (void)injectParameterNamed:(NSString*)name withDefinition:(TyphoonDefinition*)definition;
{
    [self injectParameterNamed:name withReference:definition.key];
}

- (void)injectWithDefinition:(TyphoonDefinition*)definition;
{
    [self injectParameterAtIndex:[_injectedParameters count] withDefinition:definition];
}

- (void)injectWithText:(NSString*)text
{
    [self injectParameterAt:[_injectedParameters count] withValueAsText:text requiredTypeOrNil:nil];
}

- (void)injectWithText:(NSString*)text requiredTypeOrNil:(id)requiredTypeOrNil
{
    [self injectParameterAt:[_injectedParameters count] withValueAsText:text requiredTypeOrNil:requiredTypeOrNil];
}


- (void)injectParameterAtIndex:(NSUInteger)index1 withDefinition:(TyphoonDefinition*)definition
{
    [self injectParameterAtIndex:index1 withReference:definition.key];
}

@end