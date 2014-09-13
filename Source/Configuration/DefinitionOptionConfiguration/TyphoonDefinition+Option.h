//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonDefinition.h"
#import "TyphoonOptionMatcher.h"

typedef void(^TyphoonMatcherBlock)(TyphoonOptionMatcher *matcher);

@interface TyphoonDefinition (Option)

/** if boolean 'option' value is YES, then return yesInjection, otherwise return noInjection  */
+ (id)withOption:(id)option yes:(id)yesInjection no:(id)noInjection;

/** Returns definition matching 'option', specified in 'matcherBlock' */
+ (id)withOption:(id)option matcher:(TyphoonMatcherBlock)matcherBlock;

@end



