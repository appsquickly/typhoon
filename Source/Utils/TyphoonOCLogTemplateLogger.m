//
// Created by Robert Gilliam on 11/18/13.
// Copyright (c) 2013 Jasper Blues. All rights reserved.
//


#import "TyphoonOCLogTemplateLogger.h"
#import "OCLogTemplate.h"

@implementation TyphoonOCLogTemplateLogger
{

}

- (void)logError:(NSString*)message
{
    LogError(@"%@", message);
}

@end