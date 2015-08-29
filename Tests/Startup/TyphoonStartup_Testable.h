//
//  TyphoonStartup_Testable.h
//  Typhoon
//
//  Created by Egor Tolstoy on 29/08/15.
//  Copyright © 2015 typhoonframework.org. All rights reserved.
//

#import "TyphoonStartup.h"

@class TyphoonComponentFactory;

@interface TyphoonStartup ()

+ (TyphoonComponentFactory *)factoryFromAppDelegate:(id)appDelegate;

@end
