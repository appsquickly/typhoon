////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2015, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIResponder+TyphoonOutletTransfer.h"
#import "NSLayoutConstraint+TyphoonOutletTransfer.h"
#import <objc/runtime.h>

@implementation UIResponder (TyphoonOutletTransfer)

- (void)transferFromView:(UIView *)view
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    unsigned i;
    for (i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            const char *propertyAttributes = property_getAttributes(property);
            const char *propType = getPropertyType(propertyAttributes);
            NSString *propertyType = [NSString stringWithCString:propType
                                                        encoding:[NSString defaultCStringEncoding]];
            BOOL isReadonly = isReadonlyProperty(propertyAttributes);
            if (!isReadonly && [self respondsToSelector:NSSelectorFromString(propertyName)]) {
                // IBOutlet
                if (NSClassFromString(propertyType) == [NSLayoutConstraint class]) {
                    [self transferConstraintOutletForKey:propertyName
                                                fromView:view];
                }
                // IBOutlet​Collection
                if ([NSClassFromString(propertyType) isSubclassOfClass:[NSArray class]]) {
                    [self transferConstraintOutletsForKey:propertyName
                                                 fromView:view];
                }
            }
        }
    }
    free(properties);
}

- (void)transferConstraintOutletForKey:(NSString *)propertyName
                              fromView:(UIView *)view
{
    NSLayoutConstraint *constraint = [self valueForKey:propertyName];
    if (constraint.typhoonTransferIdentifier) {
        for (NSLayoutConstraint *transferConstraint in view.constraints) {
            BOOL equalObjects = constraint == transferConstraint;
            BOOL equalIdentifier = [constraint.typhoonTransferIdentifier isEqualToString:transferConstraint.typhoonTransferIdentifier];
            if (!equalObjects && equalIdentifier) {
                [self setValue:transferConstraint
                        forKey:propertyName];
            }
        }
    }
}

- (void)transferConstraintOutletsForKey:(NSString *)propertyName
                               fromView:(UIView *)view
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@",
                              [NSLayoutConstraint class]];
    NSArray *constraints = [self valueForKey:propertyName];
    NSArray *filtered = [constraints filteredArrayUsingPredicate:predicate];
    if (filtered.count > 0) {
        BOOL needChange = NO;
        NSMutableArray *newOutlets = [NSMutableArray new];
        for (id outlet in constraints) {
            id changeOutlet = outlet;
            if ([outlet isMemberOfClass:[NSLayoutConstraint class]]) {
                NSLayoutConstraint *constraint = outlet;
                if (constraint.typhoonTransferIdentifier) {
                    for (NSLayoutConstraint *transferConstraint in view.constraints) {
                        BOOL equalObjects = constraint == transferConstraint;
                        BOOL equalIdentifier = [constraint.typhoonTransferIdentifier isEqualToString:transferConstraint.typhoonTransferIdentifier];
                        if (!equalObjects && equalIdentifier) {
                            changeOutlet = transferConstraint;
                            needChange = YES;
                        }
                    }
                }
            }
            [newOutlets addObject:changeOutlet];
        }
        
        if (needChange) {
            [self setValue:newOutlets
                    forKey:propertyName];
        }
        
    }
}

static const char *getPropertyType(const char * attributes)
{
    char buffer[1 + strlen(attributes)];
    strlcpy(buffer, attributes, sizeof(buffer));
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            if (strlen(attribute) <= 4) {
                break;
            }
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}

static BOOL isReadonlyProperty(const char * propertyAttributes)
{
    NSArray *attributes = [[NSString stringWithUTF8String:propertyAttributes]
                           componentsSeparatedByString:@","];
    return [attributes containsObject:@"R"];
}

@end
