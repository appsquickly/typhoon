////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2016, Typhoon Framework Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

#import "UIResponder+TyphoonOutletTransfer.h"
#import "NSLayoutConstraint+TyphoonOutletTransfer.h"
#import "TyphoonIntrospectionUtils.h"
#import "TyphoonTypeDescriptor.h"

@implementation UIResponder (TyphoonOutletTransfer)

- (void)transferConstraintsFromView:(UIView *)view
{
    Class currentClass = [self class];
    NSSet *properties = [TyphoonIntrospectionUtils propertiesForClass:currentClass
                                                      upToParentClass:[NSObject class]];
    for (NSString *propertyName in properties) {
        TyphoonTypeDescriptor *type = [TyphoonIntrospectionUtils typeForPropertyNamed:propertyName
                                                                              inClass:currentClass];
        SEL setter = [TyphoonIntrospectionUtils setterForPropertyWithName:propertyName
                                                                  inClass:currentClass];
        if (setter) {
            // IBOutlet
            if (type.typeBeingDescribed == [NSLayoutConstraint class]) {
                [self transferConstraintOutletForKey:propertyName
                                            fromView:view];
            }
            // IBOutlet​Collection
            if ([type.typeBeingDescribed isSubclassOfClass:[NSArray class]]) {
                [self transferConstraintOutletsForKey:propertyName
                                             fromView:view];
            }
        }
    }
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
    NSArray *constraints = [self valueForKey:propertyName];
    if ([self isOutletCollection:constraints]) {
        BOOL needChange = NO;
        NSMutableArray *newOutlets = [NSMutableArray new];
        for (NSLayoutConstraint *constraint in constraints) {
            NSLayoutConstraint *transferConstraint = [self transferConstraint:constraint
                                                                     fromView:view];
            if (transferConstraint) {
                needChange = YES;
            }
            transferConstraint = transferConstraint ? transferConstraint : constraint;
            [newOutlets addObject:transferConstraint];
        }
        
        if (needChange) {
            [self setValue:newOutlets
                    forKey:propertyName];
        }
        
    }
}

- (NSLayoutConstraint *)transferConstraint:(NSLayoutConstraint *)transferConstraint
                                  fromView:(UIView *)view
{
    if (!transferConstraint.typhoonTransferIdentifier) {
        return nil;
    }
    for (NSLayoutConstraint *constraint in view.constraints) {
        BOOL equalObjects = constraint == transferConstraint;
        BOOL equalIdentifier = [constraint.typhoonTransferIdentifier isEqualToString:transferConstraint.typhoonTransferIdentifier];
        if (!equalObjects && equalIdentifier) {
            return constraint;
        }
    }
    return nil;
}

- (BOOL)isOutletCollection:(NSArray *)array
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@",
                              [NSLayoutConstraint class]];
    NSArray *filtered = [array filteredArrayUsingPredicate:predicate];
    return filtered.count == array.count;
}

@end
