//
// Created by Aleksey Garbarev on 22.05.14.
// Copyright (c) 2014 Jasper Blues. All rights reserved.
//


#import "TyphoonDefinition.h"

@interface TyphoonOptionMatcher : NSObject

/** If 'option' equals 'optionValue' then use 'definition' */
- (void)caseOption:(id)optionValue use:(id)definition;

/** When matcher can't match definition from optionValue, use 'definition' */
- (void)defaultUse:(id)definition;

/**
* If this method called, matcher will find definition using 'option' value as key.
* @note When matching definition from 'option', 'caseOption:use:' has higher priority than matching by definition key */
- (void)useDefinitionWithKeyMatchedOptionValue;

@end

