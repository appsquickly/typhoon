////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOONFRAMEWORK.ORG
//  Copyright 2016 typhoonframework.org Pty Ltd
//  All Rights Reserved.
//
//  NOTICE: Prepared by AppsQuick.ly on behalf of typhoonframework.org. This software
//  is proprietary information. Unauthorized use is prohibited.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSInvocation+TCFCustomImplementation.h"
#import "TyphoonAssemblyDefinitionBuilder.h"

@implementation NSInvocation (TCFCustomImplementation)

- (id)argumentAtIndex:(NSInteger)index
{
    const char *type = [self.methodSignature getArgumentTypeAtIndex:(NSUInteger)index];
    
    if (IsPrimitiveArgumentType(type)) {
        return nil;
    }
    
    void *unsafeArgument;
    [self getArgument:&unsafeArgument atIndex:index];
    return (__bridge id)unsafeArgument;
}

- (void)invokeWithCustomImplementation:(IMP)impl
{
    id result = nil;

#define Arg(N) [self argumentAtIndex:N]

    switch (self.methodSignature.numberOfArguments) {
        case 2:
            result = ((id(*)(id, SEL))impl)(self.target, self.selector);
            break;
        case 3:
            result = ((id(*)(id, SEL, id))impl)(self.target, self.selector, Arg(2));
            break;
        case 4:
            result = ((id(*)(id, SEL, id, id))impl)(self.target, self.selector, Arg(2), Arg(3));
            break;
        case 5:
            result = ((id(*)(id, SEL, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4));
            break;
        case 6:
            result = ((id(*)(id, SEL, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5));
            break;
        case 7:
            result = ((id(*)(id, SEL, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6));
            break;
        case 8:
            result = ((id(*)(id, SEL, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7));
            break;
        case 9:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8));
            break;
        case 10:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9));
            break;
        case 11:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10));
            break;
        case 12:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11));
            break;
        case 13:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12));
            break;
        case 14:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12), Arg(13));
            break;
        case 15:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12), Arg(13), Arg(14));
            break;
        case 16:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12), Arg(13), Arg(14), Arg(15));
            break;
        case 17:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12), Arg(13), Arg(14), Arg(15), Arg(16));
            break;
        case 18:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12), Arg(13), Arg(14), Arg(15), Arg(16), Arg(17));
            break;
        case 19:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12), Arg(13), Arg(14), Arg(15), Arg(16), Arg(17), Arg(18));
            break;
        case 20:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12), Arg(13), Arg(14), Arg(15), Arg(16), Arg(17), Arg(18), Arg(19));
            break;
        case 21:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12), Arg(13), Arg(14), Arg(15), Arg(16), Arg(17), Arg(18), Arg(19), Arg(20));
            break;
        case 22:
            result = ((id(*)(id, SEL, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id, id))impl)(self.target, self.selector, Arg(2), Arg(3), Arg(4), Arg(5), Arg(6), Arg(7), Arg(8), Arg(9), Arg(10), Arg(11), Arg(12), Arg(13), Arg(14), Arg(15), Arg(16), Arg(17), Arg(18), Arg(19), Arg(20), Arg(21));
            break;

        default:
            NSAssert(NO, @"NSInvocation isn't supporting more than 20 arguments");
            break;
    }
    [self setReturnValue:&result];
}



@end
