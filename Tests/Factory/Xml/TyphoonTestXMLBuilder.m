//
// Created by Robert Gilliam on 11/15/13.
//


#import <Typhoon/TyphoonRXMLElement.h>
#import "TyphoonTestXMLBuilder.h"

@interface TyphoonTestXMLBuilder ()

@property(nonatomic, readwrite) NSString *class;
@property(nonatomic, readwrite) NSString *key;
@property(nonatomic, readwrite) NSMutableDictionary *attributes;

@end

@implementation TyphoonTestXMLBuilder
{

}

+ (TyphoonTestXMLBuilder *)vanillaDefinition {
    TyphoonTestXMLBuilder *builder = [[TyphoonTestXMLBuilder alloc] init];
    builder.class = @"NSObject";
    builder.key = @"vanilla";
    return builder;
}

- (id)init {
    self = [super init];
    if (self) {
        self.attributes = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (TyphoonTestXMLBuilder *)withAttribute:(NSString *)string textValue:(NSString *)textValue {
    [self.attributes setObject:textValue forKey:string];
    return self;
}

- (TyphoonRXMLElement *)build {
    NSMutableString *xmlString = [[NSMutableString alloc] init];
    [xmlString appendString:@"<component"];

    [xmlString appendFormat:@" class=\"%@\"", self.class];
    [xmlString appendFormat:@" key=\"%@\"", self.key];

    [self.attributes enumerateKeysAndObjectsUsingBlock:^(NSString *attributeName, NSString *attributeValue, BOOL *stop) {
        [xmlString appendFormat:@" %@=\"%@\"", attributeName, attributeValue];
    }];

    [xmlString appendString:@"></component>"];

    NSLog(@"Generating XML element from string: '%@'.", xmlString);
    // TODO: uncomment when we have per-file log levels.
    TyphoonRXMLElement *element = [TyphoonRXMLElement elementFromXMLString:xmlString encoding:NSUTF8StringEncoding];
    return element;
}

@end