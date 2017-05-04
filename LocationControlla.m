//
//  LocationController.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/2/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "LocationControlla.h"

@import UserNotifications;

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
    
    [[self locationManager]setDelegate:self];
    
    
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [[self locationManager] setDistanceFilter: 100];
    
    [[self locationManager] startUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    [self.delegate locationControllaUpdatedLocation:location];
}

-(void)locationManager:(CLLocationManager *)manager //ignore if in simulator
      didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Failed to find location : %@", error.localizedDescription);
    }
}

-(void)locationControllerUpdatedLocation:(CLLocation *)location{
    NSLog(@"Here is that location: Lat: %f Long: %f",location.coordinate.latitude, location.coordinate.longitude);
}

-(void)startMonitoringForRegion:(CLRegion *)region{
    [[self locationManager] startMonitoringForRegion:region];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    [content setTitle:@"Reminder"];
    [content setBody:[NSString stringWithFormat:@"%@", region.identifier]];
    [content setSound:[UNNotificationSound defaultSound]];
    
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.1 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Location Entered" content:content trigger:trigger];
    
    UNUserNotificationCenter *current = [UNUserNotificationCenter currentNotificationCenter];
    [current removeAllPendingNotificationRequests];
    [current addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to send notification: Error: %@",error.localizedDescription);
        }
    }];
    NSLog(@"User did ENTER Region: %@", region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"User did EXIT region: %@",region.identifier);
}

-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit{
    NSLog(@"didVisit: %@",visit);
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    NSLog(@"didStartMonitorForRegion: %@",region.identifier);
}


@end
