////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonInjectionContext.h"
#import "TyphoonRuntimeArguments.h"

@interface TyphoonInjectionContext ()

@property(nonatomic, strong, readwrite) TyphoonComponentFactory* factory;
@property(nonatomic, strong, readwrite) TyphoonRuntimeArguments* args;
@property(nonatomic, readwrite) BOOL raiseExceptionIfCircular;

@end

@implementation TyphoonInjectionContext

//-------------------------------------------------------------------------------------------
#pragma mark - Initialization & Destruction

- (instancetype)initWithFactory:(TyphoonComponentFactory*)factory args:(TyphoonRuntimeArguments*)args
    raiseExceptionIfCircular:(BOOL)raiseExceptionIfCircular
{
    self = [super init];
    if (self)
    {
        _factory = factory;
        _args = args;
        _raiseExceptionIfCircular = raiseExceptionIfCircular;
    }
    return self;
}

//-------------------------------------------------------------------------------------------



- (id)copyWithZone:(NSZone*)zone
{
    TyphoonInjectionContext* copied = [[TyphoonInjectionContext allocWithZone:zone] init];
    copied.factory = self.factory;
    copied.args = self.args;
    copied.destinationType = self.destinationType;
    copied.classUnderConstruction = self.classUnderConstruction;
    copied.raiseExceptionIfCircular = self.raiseExceptionIfCircular;
    return copied;
}

@end
