//
//  LocationController.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/2/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "LocationControlla.h"

@interface LocationControlla () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@end
@implementation LocationControlla

+(instancetype)shared{
    static LocationControlla *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[[self class] alloc] init];
    });
    return shared;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self requestPermissions];
        self.location = [[CLLocation alloc] init];
    }
    
    return self;
}


-(void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc]init];
    
    [[self locationManager] requestAlwaysAuthorization];
    
    self.locationManager.delegate = self;
    
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [[self locationManager] setDistanceFilter: 100];
    
    [[self locationManager] startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    [self.delegate locationControllerUpdatedLocation:location];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Failed to find location : %@", error.localizedDescription);
    }
}

-(void)locationControllerUpdatedLocation:(CLLocation *)location{
    NSLog(@"Here is that location: Lat: %f Long: %f",location.coordinate.latitude, location.coordinate.longitude);
}

@end
