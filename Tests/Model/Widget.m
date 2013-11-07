//
// Created by Robert Gilliam on 11/7/13.
//


#import "Widget.h"


@implementation Widget {

}

- (instancetype)initWithName:(NSString*)aName
{
    self = [super init];
    if (self) {
        _name = aName;
    }

    return self;
}


- (instancetype)initWithWidgetC:(Widget*)aWidgetC
{
    self = [super init];
    if (self) {
       _widgetC = aWidgetC;
    }

    return self;
}

- (instancetype)initWithWidgetA:(Widget*)aWidgetA widgetB:(Widget*)aWidgetB
{
    self = [super init];
    if (self) {
      _widgetA = aWidgetA;
        _widgetB = aWidgetB;
    }

    return self;
}


@end