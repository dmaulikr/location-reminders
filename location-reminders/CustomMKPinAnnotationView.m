//
//  CustomMKAnnotationView.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/1/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "CustomMKPinAnnotationView.h"
#import <UIKit/UIKit.h>

@implementation CustomMKPinAnnotationView

-(instancetype)initWithTitle:(NSString *)title withAnnotation:(id)annotation{
    self = [super initWithAnnotation:annotation reuseIdentifier:@"annotation"];

    if (self) {
        self.animatesDrop = YES;
        self.annotation = annotation;
        self.canShowCallout = YES;
        self.draggable = NO;
        [self setUpInfoButton];
    }
    return self;
}

-(void)setUpInfoButton{
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    self.rightCalloutAccessoryView = infoButton;
    
}

@end
