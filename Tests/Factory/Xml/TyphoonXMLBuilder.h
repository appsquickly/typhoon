//
// Created by Robert Gilliam on 11/15/13.
//


#import <Foundation/Foundation.h>


@interface TyphoonXMLBuilder : NSObject

+ (TyphoonXMLBuilder*)vanillaDefinition;

- (TyphoonXMLBuilder*)withAttribute:(NSString*)string textValue:(NSString*)value;
- (TyphoonRXMLElement*)build;

@property(nonatomic, readonly) NSString* class;
@property(nonatomic, readonly) NSString* key;

@end