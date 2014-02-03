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

#include "TyphoonFactoryProviderTestHelper.h"

#include <objc/runtime.h>

Protocol *protocol_clone(Protocol *original)
{
    static int counter = 0;

    NSString *protocolName = [NSString stringWithFormat:@"%s%d", protocol_getName(original), counter++];
    Protocol *protocol = objc_allocateProtocol([protocolName UTF8String]);

    unsigned int count = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(original, YES, YES, &count);
    for (unsigned int idx = 0; idx < count; idx++){ protocol_addMethodDescription(protocol, methods[idx].name, methods[idx].types, YES, YES);}
    free(methods);

    methods = protocol_copyMethodDescriptionList(original, YES, NO, &count);
    for (unsigned int idx = 0; idx < count; idx++){ protocol_addMethodDescription(protocol, methods[idx].name, methods[idx].types, YES, NO);}
    free(methods);

    methods = protocol_copyMethodDescriptionList(original, NO, YES, &count);
    for (unsigned int idx = 0; idx < count; idx++){ protocol_addMethodDescription(protocol, methods[idx].name, methods[idx].types, NO, YES);}
    free(methods);

    methods = protocol_copyMethodDescriptionList(original, NO, NO, &count);
    for (unsigned int idx = 0; idx < count; idx++){ protocol_addMethodDescription(protocol, methods[idx].name, methods[idx].types, NO, NO);}
    free(methods);

    objc_property_t *properties = protocol_copyPropertyList(original, &count);
    for (unsigned int idx = 0; idx < count; idx++) {
        const char *name = property_getName(properties[idx]);
        unsigned int count2 = 0;
        objc_property_attribute_t *attrs = property_copyAttributeList(properties[idx], &count2);
        // FIXME: the fifth parameter is require/optional. I haven't seen
        // optional properties that much, and since this is just a helper method
        // I don't see the need to support optional properties.
        protocol_addProperty(protocol, name, attrs, count, YES, YES);
        free(attrs);
    }
    free(properties);

    Protocol *__unsafe_unretained *protocols = protocol_copyProtocolList(original, &count);
    for (unsigned int idx = 0; idx < count; idx++){ protocol_addProtocol(protocol, protocols[idx]);}
    free(protocols);

    objc_registerProtocol(protocol);

    return objc_getProtocol([protocolName UTF8String]);
}
