//
// Created by Robert Gilliam on 11/18/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import "TyphoonOCLogTemplateLogger.h"
#import "OCLogTemplate.h"

@implementation TyphoonOCLogTemplateLogger
{

}

- (void)logWarn:(NSString*)message
{
    LogInfo(@"%@", message);
}

@end