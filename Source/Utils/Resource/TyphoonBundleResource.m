////////////////////////////////////////////////////////////////////////////////
//
//  JASPER BLUES
//  Copyright 2012 - 2013 Jasper Blues
//  All Rights Reserved.
//
//  NOTICE: Jasper Blues permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////


#import "TyphoonBundleResource.h"


@implementation TyphoonBundleResource

/* =========================================================== Class Methods ============================================================ */
+ (id <TyphoonResource>)withName:(NSString*)name
{

    NSString* contents;
    NSString* filePath;
    NSRange lastDot = [name rangeOfString:@"." options:NSBackwardsSearch];
    if (lastDot.location != NSNotFound)
    {
        NSString* resource = [name substringToIndex:lastDot.location];
        NSString* type = [name substringFromIndex:lastDot.location + 1];
        NSLog(@"Resource: %@.%@", resource, type);
        filePath = [[NSBundle bundleForClass:[self class]] pathForResource:resource ofType:type];
    }
    else
    {
        filePath = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:nil];
    }
    if (filePath == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Resource named '%@' not in bundle.", name];
    }
    contents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [[[self class] alloc] initWithStringValue:contents];
}

/* ============================================================ Initializers ============================================================ */
- (id)initWithStringValue:(NSString*)stringValue
{
    self = [super init];
    if (self)
    {
        _stringValue = stringValue;
    }

    return self;
}

- (NSString*)asString
{
    return _stringValue;
}


@end