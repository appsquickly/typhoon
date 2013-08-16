////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

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
