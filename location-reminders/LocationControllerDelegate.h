//
//  LocationControllerDelegate.h
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/2/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@protocol LocationControllerDelegate <NSObject>

-(void)locationControllerUpdatedLocation:(CLLocation *)location;

@end
