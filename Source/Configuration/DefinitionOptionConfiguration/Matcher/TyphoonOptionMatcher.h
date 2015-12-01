////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "TyphoonDefinition.h"

@interface TyphoonOptionMatcher : NSObject

/** If 'option' equals 'optionValue' then use 'injection' */
- (void)caseEqual:(id)optionValue use:(id)injection;

/** If 'option' is kind of class 'optionClass' then use 'injection' */
- (void)caseKindOfClass:(Class)optionClass use:(id)injection;

/** If 'option' is member of class 'optionClass' then use 'injection' */
- (void)caseMemberOfClass:(Class)optionClass use:(id)injection;

/** If 'option' conforms to protocol 'optionProtocol' then use 'injection' */
- (void)caseConformsToProtocol:(Protocol *)optionProtocol use:(id)injection;

/** When matcher can't match injection from optionValue, use 'injection' */
- (void)defaultUse:(id)injection;

/**
* If this method called, matcher will find definition using 'option' value as key for definition.
* @note When matching definition from 'option', 'caseEqual:use:', 'caseKindOfClass:use:' and 'caseMemberOfClass:use:' has higher priority than matching by definition key */
- (void)useDefinitionWithKeyMatchedOptionValue;

@end

