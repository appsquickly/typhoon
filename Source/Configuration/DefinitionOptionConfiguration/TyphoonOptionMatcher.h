//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//


#import "TyphoonDefinition.h"

@interface TyphoonOptionMatcher : NSObject

/** If 'option' equals 'optionValue' then use 'injection' */
- (void)caseEqual:(id)optionValue use:(id)injection;

/** If 'option' is kind of class 'optionClass' then use 'injection' */
- (void)caseKindOfClass:(Class)optionClass use:(id)injection;

/** If 'option' is member of class 'optionClass' then use 'injection' */
- (void)caseMemberOfClass:(Class)optionClass use:(id)injection;

/** When matcher can't match injection from optionValue, use 'injection' */
- (void)defaultUse:(id)injection;

/**
* If this method called, matcher will find definition using 'option' value as key.
* @note When matching definition from 'option', 'caseEqual:use:' has higher priority than matching by definition key */
- (void)useDefinitionWithKeyMatchedOptionValue;

@end

