////////////////////////////////////////////////////////////////////////////////
//
// TYPHOON FRAMEWORK
// Copyright 2014, Typhoon Framework Contributors
// All Rights Reserved.
//
// NOTICE: The authors permit you to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

/** TyphoonUtils category used to move NSInvocation invoking logic into non-arc file
  * The problem was when calling 'init' method through NSInvocation on instance created
  * by 'alloc' in ARC-managed file.
  * @code
 {
    id instance = [aClass alloc];           
    //ARC transfer ownership to strong local variable 'instance' (retainCount = 1)
    
    [invocation setSelector:@selector(initWith..)];

    //in some cases, 'initWith..' method can create new instance and release firstly created 'instance'
    //If it happens 'instance' will be dealloced (retainCount = 0)
    [invocation invokeWithTarget:instance];
 }          
 //'instance' is out of scope. ARC Releases 'instance' - crash if already dealloced
  * @endcode
  * To fix this problem we decided to move 'alloc' and NSInvocation with 'initWith..' into non-arc
  * file and do all right and manually.
  * 
  * Objects returned by methods from this category are retained, so you responsable to release,  
  * or ARC will do it for you gracefully
 */
@interface NSInvocation (TCFInstanceBuilder)

/** Return result of invoking self on provided instance. Note that result is retained */
- (id)typhoon_resultOfInvokingOnInstance:(id)instance NS_RETURNS_RETAINED;

/** Creates instance by 'alloc' message on given class and returns result of invoking self on created instance. Note that result is retained */
- (id)typhoon_resultOfInvokingOnAllocationForClass:(Class)aClass NS_RETURNS_RETAINED;

@end
