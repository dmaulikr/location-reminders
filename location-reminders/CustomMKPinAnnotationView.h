//
//  CustomMKAnnotationView.h
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/1/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomMKPinAnnotationView : MKPinAnnotationView


-(instancetype)initWithTitle:(NSString *)title withAnnotation:(id)annotation;
@end
