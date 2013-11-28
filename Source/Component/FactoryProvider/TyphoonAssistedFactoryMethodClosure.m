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

#import "TyphoonAssistedFactoryMethodClosure.h"

#include <ffi.h>

#import "TyphoonAssistedFactoryMethodInitializer.h"
#import "TyphoonAssistedFactoryParameterInjectedWithArgumentIndex.h"
#import "TyphoonAssistedFactoryParameterInjectedWithProperty.h"

@implementation TyphoonAssistedFactoryMethodClosure
{
    Class _returnType;
    SEL _initSelector;
    NSArray *_parameters;

    NSMutableArray *_allocations;
    ffi_cif _closureCIF;
    ffi_cif _initCIF;
    ffi_closure *_closure;
    void *_closureFptr;
}

static void FactoryMethodClosure(ffi_cif *cif, void *ret, void **args, void *userdata)
{
    TyphoonAssistedFactoryMethodClosure *closure = (__bridge TyphoonAssistedFactoryMethodClosure *)userdata;

    void **arguments = calloc(closure->_parameters.count + 2, sizeof(void *));
    NSArray *tempAllocations = [closure prepareArgumentsWithValues:args into:arguments];
    ffi_call(&(closure->_initCIF), FFI_FN(objc_msgSend), ret, arguments);
    free(arguments);
    tempAllocations = nil;
}

// Taken from MABlockClosure
static const char *SizeAndAlignment(const char *str, NSUInteger *sizep, NSUInteger *alignp, long *len)
{
    const char *out = NSGetSizeAndAlignment(str, sizep, alignp);
    if(len)
        *len = out - str;
    while(isdigit(*out))
        out++;
    return out;
}


static unsigned int ArgCount(const char *str)
{
    int argcount = -1; // return type is the first one
    while(str && *str)
    {
        str = SizeAndAlignment(str, NULL, NULL, NULL);
        argcount++;
    }
    return argcount;
}
// End of MABlockClosure code

- (instancetype)initWithInitializer:(TyphoonAssistedFactoryMethodInitializer *)initializer methodDescription:(struct objc_method_description)methodDescription
{
    self = [super init];
    if (self)
    {
        NSParameterAssert(initializer.returnType);
        NSParameterAssert(initializer.selector);

        _returnType = initializer.returnType;
        _initSelector = initializer.selector;
        _parameters = initializer.parameters;

        _allocations = [[NSMutableArray alloc] init];
        _closure = ffi_closure_alloc(sizeof(ffi_closure), &_closureFptr);

        [self prepareClosureCIFWithMethodDescription:methodDescription];
        [self prepareInitializerCIF];

        ffi_status status = ffi_prep_closure_loc(_closure, &_closureCIF, FactoryMethodClosure, (__bridge void *)(self), _closureFptr);
        NSAssert(status == FFI_OK, @"ffi_prep_closure_loc returned %d", status);
    }

    return self;
}

- (void)dealloc
{
    if (_closure != NULL) ffi_closure_free(_closure);
}

- (void *)fptr
{
    return _closureFptr;
}

- (void)prepareClosureCIFWithMethodDescription:(struct objc_method_description)methodDescription
{
    unsigned int count;
    ffi_type **closureArgumentTypes = [self typesWithEncodeString:methodDescription.types count:&count];

    // NOTE: we can do a validation that every input argument is used, but I
    // think that a validation like that can hurt some refactors (one argument
    // is left unused in the initializer, but you don't want to rename all the
    // factory methods just now).

    ffi_status status = ffi_prep_cif(&_closureCIF, FFI_DEFAULT_ABI, count, &ffi_type_pointer, closureArgumentTypes);
    NSAssert(status == FFI_OK, @"ffi_prep_cif returned %d", status);
}

- (void)prepareInitializerCIF
{
    Method method = class_getInstanceMethod(_returnType, _initSelector);
    NSAssert(method != NULL, @"Could not find [%s %s]", class_getName(_returnType), sel_getName(_initSelector));

    unsigned int count;
    ffi_type **initArgumentTypes = [self typesWithEncodeString:method_getTypeEncoding(method) count:&count];

    NSAssert([self validateInitializerParameterCount:count - 2], @"parameter map for %s do not fill all %u parameters", sel_getName(_initSelector), count);

    ffi_status status = ffi_prep_cif(&_initCIF, FFI_DEFAULT_ABI, count, &ffi_type_pointer, initArgumentTypes);
    NSCAssert(status == FFI_OK, @"ffi_prep_cif returned %d", status);
}

- (NSArray *)prepareArgumentsWithValues:(void **)arguments into:(void **)output
{
    // Don't use _allocations here, or we will leak memory.
    NSMutableArray *temporalAllocations = [NSMutableArray array];

    id instance = [_returnType alloc];
    [temporalAllocations addObject:instance];
    void **instancePointer = [self temporalAllocate:sizeof(void **) inArray:temporalAllocations];
    *instancePointer = (__bridge void *)instance;

    output[0] = instancePointer;
    output[1] = &_initSelector;

    for (id<TyphoonAssistedFactoryInjectedParameter> parameter in _parameters) {
        // Move to other solution which doesn't involve isKindOf?
        if ([parameter isKindOfClass:[TyphoonAssistedFactoryParameterInjectedWithArgumentIndex class]]) {
            TyphoonAssistedFactoryParameterInjectedWithArgumentIndex *p = parameter;
            output[[p parameterIndex] + 2] = arguments[[p argumentIndex] + 2];
        } else if ([parameter isKindOfClass:[TyphoonAssistedFactoryParameterInjectedWithProperty class]]) {
            TyphoonAssistedFactoryParameterInjectedWithProperty *p = parameter;

            // Super-crazy cast...
            id factory = (__bridge id)*(void **)arguments[0];

            NSString *selector = [NSString stringWithCString:sel_getName([p property]) encoding:NSASCIIStringEncoding];
            id value = [factory valueForKey:selector];
            [temporalAllocations addObject:value];

            void **valuePointer = [self temporalAllocate:sizeof(void **) inArray:temporalAllocations];
            *valuePointer = (__bridge void *)value;

            output[[p parameterIndex] + 2] = valuePointer;
        } else {
            NSAssert(NO, @"Unknown parameter type %s", class_getName([parameter class]));
        }
    }

    return temporalAllocations;
}

- (BOOL)validateInitializerParameterCount:(unsigned int)count
{
    NSMutableIndexSet *parameters = [NSMutableIndexSet indexSet];

    for (id<TyphoonAssistedFactoryInjectedParameter> parameter in _parameters) {
        [parameters addIndex:[parameter parameterIndex]];
    }

    return [parameters containsIndexesInRange:NSMakeRange(0, count)];
}

// Taken from MABlockClosure
- (void *)allocate:(size_t)howmuch
{
    NSMutableData *data = [NSMutableData dataWithLength:howmuch];
    [_allocations addObject:data];
    return [data mutableBytes];
}

- (void *)temporalAllocate:(size_t)howmuch inArray:(NSMutableArray *)array
{
    NSMutableData *data = [NSMutableData dataWithLength:howmuch];
    [array addObject:data];
    return [data mutableBytes];
}

- (ffi_type **)typesWithEncodeString:(const char *)encodeString count:(unsigned int *)count
{
    unsigned int argCount = ArgCount(encodeString);
    ffi_type **argTypes = [self allocate:argCount * sizeof(ffi_type *)];

    int i = -1;
    while(encodeString && *encodeString)
    {
        const char *next = SizeAndAlignment(encodeString, NULL, NULL, NULL);
        if(i >= 0)
            argTypes[i] = [self ffiArgForEncode:encodeString];
        i++;
        encodeString = next;
    }

    if (count != NULL) *count = argCount;

    return argTypes;
}

- (ffi_type *)ffiArgForEncode:(const char *)str
{
#define SINT(type) do { \
    if(str[0] == @encode(type)[0]) \
    { \
        if(sizeof(type) == 1) \
            return &ffi_type_sint8; \
        else if(sizeof(type) == 2) \
            return &ffi_type_sint16; \
        else if(sizeof(type) == 4) \
            return &ffi_type_sint32; \
        else if(sizeof(type) == 8) \
            return &ffi_type_sint64; \
        else \
        { \
            NSLog(@"Unknown size for type %s", #type); \
            abort(); \
        } \
    } \
} while(0)

#define UINT(type) do { \
    if(str[0] == @encode(type)[0]) \
    { \
        if(sizeof(type) == 1) \
            return &ffi_type_uint8; \
        else if(sizeof(type) == 2) \
            return &ffi_type_uint16; \
        else if(sizeof(type) == 4) \
            return &ffi_type_uint32; \
        else if(sizeof(type) == 8) \
            return &ffi_type_uint64; \
        else \
        { \
            NSLog(@"Unknown size for type %s", #type); \
            abort(); \
        } \
    } \
} while(0)

#define INT(type) do { \
    SINT(type); \
    UINT(unsigned type); \
} while(0)

#define COND(type, name) do { \
    if(str[0] == @encode(type)[0]) \
    return &ffi_type_ ## name; \
} while(0)

#define PTR(type) COND(type, pointer)

#define STRUCT(structType, ...) do { \
    if(strncmp(str, @encode(structType), strlen(@encode(structType))) == 0) \
    { \
        ffi_type *elementsLocal[] = { __VA_ARGS__, NULL }; \
        ffi_type **elements = [self allocate:sizeof(elementsLocal)]; \
        memcpy(elements, elementsLocal, sizeof(elementsLocal)); \
        \
        ffi_type *structType = [self allocate:sizeof(*structType)]; \
        structType->type = FFI_TYPE_STRUCT; \
        structType->elements = elements; \
        return structType; \
    } \
} while(0)

    SINT(_Bool);
    SINT(signed char);
    UINT(unsigned char);
    INT(short);
    INT(int);
    INT(long);
    INT(long long);

    PTR(id);
    PTR(Class);
    PTR(SEL);
    PTR(void *);
    PTR(char *);
    PTR(void (*)(void));

    COND(float, float);
    COND(double, double);

    COND(void, void);

    ffi_type *CGFloatFFI = sizeof(CGFloat) == sizeof(float) ? &ffi_type_float : &ffi_type_double;
    STRUCT(CGRect, CGFloatFFI, CGFloatFFI, CGFloatFFI, CGFloatFFI);
    STRUCT(CGPoint, CGFloatFFI, CGFloatFFI);
    STRUCT(CGSize, CGFloatFFI, CGFloatFFI);

#if !TARGET_OS_IPHONE
    STRUCT(NSRect, CGFloatFFI, CGFloatFFI, CGFloatFFI, CGFloatFFI);
    STRUCT(NSPoint, CGFloatFFI, CGFloatFFI);
    STRUCT(NSSize, CGFloatFFI, CGFloatFFI);
#endif

    NSLog(@"Unknown encode string %s", str);
    abort();
}

// End of MABlockClosure code

@end
