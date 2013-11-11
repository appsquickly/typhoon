//
// Created by Robert Gilliam on 11/7/13.
//


#import <Foundation/Foundation.h>


@interface Widget : NSObject

- (instancetype)initWithName:(NSString* )aName;
- (instancetype)initWithWidgetC:(Widget *)aWidgetC;
- (instancetype)initWithWidgetA:(Widget *)aWidgetA widgetB:(Widget* )aWidgetB;

@property Widget* widgetA;
@property Widget* widgetB;
@property Widget* widgetC;

@property NSString *name;

@end