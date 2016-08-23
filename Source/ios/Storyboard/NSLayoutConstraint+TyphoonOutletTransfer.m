////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "NSLayoutConstraint+TyphoonOutletTransfer.h"
#import <objc/runtime.h>

@implementation NSLayoutConstraint (TyphoonOutletTransfer)

- (void)setTyphoonTransferIdentifier:(NSString *)identifier {
    objc_setAssociatedObject(self, @selector(typhoonTransferIdentifier), identifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)typhoonTransferIdentifier {
    return objc_getAssociatedObject(self, @selector(typhoonTransferIdentifier));
}

- (void)setTyphoonTransferConstraint:(NSLayoutConstraint *)typhoonTransferConstraint {
    objc_setAssociatedObject(self, @selector(typhoonTransferConstraint), typhoonTransferConstraint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSLayoutConstraint *)typhoonTransferConstraint {
    return objc_getAssociatedObject(self, @selector(typhoonTransferConstraint));
}

@end
