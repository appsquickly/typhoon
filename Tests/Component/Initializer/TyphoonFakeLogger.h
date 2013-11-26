//
// Created by Robert Gilliam on 11/18/13.
//


#import <Foundation/Foundation.h>
#import "TyphoonLogger.h"


@interface TyphoonFakeLogger : NSObject <TyphoonLogger>

@property(readonly) NSString *lastReceivedMessage;

- (void)shouldHaveLogged:(NSString*)string;

- (instancetype)initWithTestCase:(SenTestCase*)testCase;

+ (instancetype)loggerWithTestCase:(SenTestCase*)testCase;

@end