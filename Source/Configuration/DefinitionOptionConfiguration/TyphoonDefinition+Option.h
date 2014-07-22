//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonDefinition.h"
#import "TyphoonOptionMatcher.h"

typedef void(^TyphoonMatcherBlock)(TyphoonOptionMatcher *matcher);

@interface TyphoonDefinition (Option)

/** if boolean 'option' value is YES, then return yesDefinition, otherwise return noDefinition  */
+ (TyphoonDefinition *)withOption:(id)option yes:(id)yesDefinition no:(id)noDefinition;

/** Returns definition matching 'option', specified in 'matcherBlock' */
+ (TyphoonDefinition *)withOption:(id)option matcher:(TyphoonMatcherBlock)matcherBlock;

@end



