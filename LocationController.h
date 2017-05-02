//
//  LocationController.h
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/2/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationControllerDelegate.h"
@import CoreLocation;

@interface LocationController : NSObject {
    id <LocationControllerDelegate> delegate;
}
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (weak, nonatomic) id delegate;


@end
