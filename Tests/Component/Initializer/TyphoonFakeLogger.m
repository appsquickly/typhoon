//
// Created by Robert Gilliam on 11/18/13.
//


#import <SenTestingKit/SenTestingKit.h>
#import "TyphoonFakeLogger.h"


@implementation TyphoonFakeLogger
{
    SenTestCase* _testCase;
}

- (void)logWarn:(NSString*)message
{
    _lastReceivedMessage = message;
}


- (instancetype)initWithTestCase:(SenTestCase*)testCase
{
    self = [super init];
    if (self)
    {
        _testCase = testCase;
    }

    return self;
}

+ (instancetype)loggerWithTestCase:(SenTestCase*)testCase
{
    return [[self alloc] initWithTestCase:testCase];
}


- (void)shouldHaveLogged:(NSString*)string
{
    if (![_lastReceivedMessage isEqualToString:string]) {
        if (_testCase) {
            NSString* reason = [NSString stringWithFormat:@"Last message logged should have been '%@'\nbut was '%@'."];
            NSException* anException = [[NSException alloc]
                    initWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
            [_testCase failWithException:anException];
        }else{
            [NSException raise:NSInternalInconsistencyException format:@"Last message logged should have been '%@'\nbut was '%@'."];
        }
    }
}

@end