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

#import <Foundation/Foundation.h>
#import "TyphoonComponentFactory.h"

@class TyphoonComponentFactory;
@class TyphoonAssembly;
@class TyphoonAssemblyDefinitionBuilder;

@interface TyphoonAssemblyAccessor : NSObject <TyphoonComponentFactory>

@property (nonatomic, weak) TyphoonComponentFactory *factory;
@property (nonatomic, weak) TyphoonAssembly *assembly;
@property (nonatomic, weak) TyphoonAssemblyDefinitionBuilder *definitionBuilder;

@property (nonatomic, strong) NSDictionary<NSString *, TyphoonAssembly *> *collaboratingAssemblies;

@end
