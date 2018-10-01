//
//  Viper.h
//  Typhoon-iOS
//
//  Created by Aleksey Garbarev on 01/10/2018.
//  Copyright © 2018 typhoonframework.org. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : NSObject
@property (nonatomic, strong) id output;
@end

@interface LoginPresenter : NSObject
@property (nonatomic, weak) id view;
@property (nonatomic, strong) id interactor;
@property (nonatomic, strong) id router;
@end

@interface LoginInteractor : NSObject
@property (nonatomic, weak) id output;
@end

@interface LoginRouter : NSObject
@property (nonatomic, strong) id routeRegistration;

@end

@interface JRViewControllerRoute : NSObject
@property (nonatomic, weak) id owner;
@property (nonatomic, copy) UIViewController*(^destinationFactoryBlock)();
@end

NS_ASSUME_NONNULL_END
