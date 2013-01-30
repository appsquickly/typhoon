////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "TyphoonDefinition.h"
#import "TyphoonDefinition+BlockBuilders.h"
#import "TyphoonInitializer.h"
#import "TyphoonPropertyPlaceholderConfigurer.h"
#import "TyphoonResource.h"
#import "TyphoonBundleResource.h"
#import "TyphoonComponentFactory.h"
#import "TyphoonComponentFactory+InstanceBuilder.h"
#import "TyphoonXmlComponentFactory.h"
#import "TyphoonComponentFactoryMutator.h"
#import "TyphoonRXMLElement+XmlComponentFactory.h"
#import "TyphoonRXMLElement.h"
#import "TyphoonTestUtils.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonAssembly.h"

//TODO: Possibly move this to make explicit
#import "TyphoonInitializer+BlockAssembly.h"
#import "TyphoonDefinition+BlockAssembly.h"

#define typhoon_autoWire(args...) \
    + (NSSet *)typhoonAutoInjectedProperties { \
        NSMutableSet* autoInjectProperties = [NSMutableSet set]; \
        SEL the_selectors[] = {args}; \
        int argCount = (sizeof((SEL[]){args})/sizeof(SEL)); \
        for (int i = 0; i < argCount; i++) { \
            SEL selector = the_selectors[i]; \
            [autoInjectProperties addObject:NSStringFromSelector(selector)]; \
        } \
        return TyphoonAutoWiredProperties(self, autoInjectProperties); \
    }

#ifdef typhoon_shorthand
#define autoWire typhoon_autoWire
#endif

