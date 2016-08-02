//
//  LoadedView.h
//  Typhoon
//
//  Created by Smal Vadim on 01/08/16.
//  Copyright © 2016 typhoonframework.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadedView : UIView

@property (strong, nonatomic) NSNumber *injectedValue;

+ (instancetype)loadFromNib;

@end
