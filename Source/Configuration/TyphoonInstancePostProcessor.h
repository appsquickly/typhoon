////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2014, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

@class TyphoonDefinition;

/**
* @ingroup Factory
*
 Allows for custom modification of a component after its instantiation.

 Component factories can auto-detect TyphoonInstancePostProcessor components in their definitions and will apply them to components created
 by the factory.
 */
@protocol TyphoonInstancePostProcessor<NSObject>

/**
 Post process a component after its initialization and return the processed component.
*/
- (id)postProcessComponent:(id)component withDefinition:(TyphoonDefinition *)definition;


@end