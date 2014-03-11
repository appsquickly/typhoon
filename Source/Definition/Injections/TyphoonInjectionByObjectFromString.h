//
//  TyphoonInjectionByObjectFromString.h
//  A-Typhoon
//
//  Created by Aleksey Garbarev on 12.03.14.
//  Copyright (c) 2014 Jasper Blues. All rights reserved.
//

#import "TyphoonAbstractInjection.h"
#import "TyphoonInjectedWithStringRepresentation.h"

@interface TyphoonInjectionByObjectFromString : TyphoonAbstractInjection<TyphoonInjectedWithStringRepresentation>

@property (nonatomic, strong) NSString *textValue;
@property (nonatomic, strong, readonly) Class requiredClass;

- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string objectClass:(Class)requiredClass;

@end
