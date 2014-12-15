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
#import "TyphoonOptionMatcher.h"

@protocol TyphoonAutoInjectionConfig;
typedef void(^TyphoonMatcherBlock)(TyphoonOptionMatcher *matcher);

@interface TyphoonDefinition (Option)

/** if boolean 'option' value is YES, then return yesInjection, otherwise return noInjection  */
+ (id)withOption:(id)option yes:(id)yesInjection no:(id)noInjection;

/** Returns definition matching 'option', specified in 'matcherBlock' */
+ (id)withOption:(id)option matcher:(TyphoonMatcherBlock)matcherBlock;

+ (id)withOption:(id)option matcher:(TyphoonMatcherBlock)matcherBlock autoInjectionConfig:(void(^)(id<TyphoonAutoInjectionConfig> config))configBlock;

@end


@protocol TyphoonAutoInjectionConfig<NSObject>

@property (nonatomic, strong) id classOrProtocolForAutoInjection;
@property (nonatomic) TyphoonAutoInjectVisibility autoInjectionVisibility;

@end


