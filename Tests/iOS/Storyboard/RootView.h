//
//  RootView.h
//  Typhoon
//
//  Created by Smal Vadim on 01/08/16.
//  Copyright © 2016 typhoonframework.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadedView;

@interface RootView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *outlets;


@property (weak, nonatomic) IBOutlet LoadedView *loadedView;
@property (weak, nonatomic) IBOutlet RootView *anotherView;

@end
