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

#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (TyphoonOutletTransfer)

// Identifier for compare constraints for transfer
@property (nonatomic, strong) NSString *typhoonTransferIdentifier;

// Retain constraint from TyphoonLoadedView
@property (nonatomic, strong) NSLayoutConstraint *typhoonTransferConstraint;

@end
