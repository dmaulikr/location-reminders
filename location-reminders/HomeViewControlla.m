//
//  ViewController.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/1/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "HomeViewControlla.h"

#import "AddReminderViewControlla.h"

#import "CustomMKPinAnnotationView.h"


@import Parse;
@import MapKit;


@interface HomeViewControlla () <MKMapViewDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation HomeViewControlla
- (IBAction)dropPin:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.view];
        
        NSLog(@"The coordinate of tapped location: Lat:%f Lon: %f", coordinate.latitude, coordinate.longitude);
        
        MKPointAnnotation * newPoint = [[MKPointAnnotation alloc]init];
        
        newPoint.coordinate = coordinate;
        
        newPoint.title = @"Title";
    }
    

    
    
}

- (IBAction)selectMapType:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex){
        case 0:
            [self changeMapView:MKMapTypeStandard];
            break;
        case 1:
            [self changeMapView:MKMapTypeHybrid];
            break;
        case 2:
            [self changeMapView:MKMapTypeSatellite];
            break;
        default:
            break;
    }
}

- (IBAction)segmentedControl:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex){
        case 0:
            NSLog(@"Selected Mount Rushmore");
            [self setLocationWithLatitude:43.8791 AndLongitude:-103.4591];
            [self setCustomAnnotationsWithTitle:@"Mount Rushmore"
                                    andLatitude:43.8791
                                   AndLongitude:-103.4591];
            break;
        case 1:
            NSLog(@"Selected Hollywood");
            [self setLocationWithLatitude:34.0928 AndLongitude:-118.3287];
            [self setCustomAnnotationsWithTitle:@"Hollywood"
                                    andLatitude:34.0928
                                   AndLongitude:-118.3287];
            break;
        case 2:
            NSLog(@"Selected Eiffel Tower");
            [self setLocationWithLatitude:48.8584 AndLongitude:2.2945];
            [self setCustomAnnotationsWithTitle:@"Eiffel Tower"
                                    andLatitude:48.8584
                                   AndLongitude:2.2945];
        default:
            break;
            
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPermissions];
    [[self mapView] setDelegate: self];
    [[self mapView] setShowsUserLocation:YES];
    
    [self setLocationWithLatitude:self.mapView.userLocation.coordinate.latitude
                     AndLongitude:self.mapView.userLocation.coordinate.longitude];
}


#pragma MapKit helper methods
-(void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc]init];
    [[self locationManager] setDelegate:self];
    [[self locationManager] setDesiredAccuracy:kCLLocationAccuracyBest];
    [[self locationManager] setDistanceFilter:100]; //Meters
    [[self locationManager] requestAlwaysAuthorization];
    [[self locationManager] startUpdatingLocation];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    if ([[segue identifier] isEqualToString:@"AddReminderViewControlla"] && [sender isKindOfClass:[MKAnnotationView class]]) {
        MKAnnotationView *annotationView = (MKAnnotationView *)sender;
        AddReminderViewControlla *destinationController = (AddReminderViewControlla *)segue.destinationViewController;
        [destinationController setCoordinate:annotationView.annotation.coordinate];
        [destinationController setAnnotationTitle:annotationView.annotation.title];
        [destinationController setTitle:@"Add Reminder"];
    }
}

-(void)setLocationWithLatitude:(CGFloat)latitude AndLongitude:(CGFloat)longitude{

    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 500.00, 500.00);
    [[self mapView] setRegion:region animated:YES];
}

-(void)changeMapView:(MKMapType)mapType{
    [[self mapView]setMapType:mapType];
}


-(void)setCustomAnnotationsWithTitle:(NSString *)title andLatitude:(CGFloat)latitude AndLongitude:(CGFloat)longitude {
    
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(latitude, longitude);
    
    MKPointAnnotation *annotation;
    
    BOOL hasAnnotation = NO;
    for (MKPointAnnotation *a in self.mapView.annotations) {
        if ((a.coordinate.latitude == coordinates.latitude) && (a.coordinate.longitude == coordinates.longitude)) {
            annotation = a;
            hasAnnotation = YES;
        }
    }
    if (!hasAnnotation) {
        annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate: coordinates];
        [annotation setTitle: title];
        [[self mapView] addAnnotation:annotation];
    }
    [[self mapView] selectAnnotation:annotation animated:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 500.0, 500.0);
    
    [[self mapView] setRegion:region animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if (error) {
        NSLog(@"Failed to find location : %@", error.localizedDescription);
    }
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"The callout button associated with %@", view.annotation.title);
    [self performSegueWithIdentifier:@"AddReminderViewControlla" sender:view];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    NSLog(@"Inside of viewForAnnotation:");
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    CustomMKPinAnnotationView *myAnnotationView = (CustomMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (!myAnnotationView){
        myAnnotationView = [[CustomMKPinAnnotationView alloc] initWithTitle:annotation.title withAnnotation:annotation];
    }
    [myAnnotationView setAnimatesDrop:YES];
    return myAnnotationView;
}


//
//    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//
//    testObject[@"testName"] = @"Castro";
//
//    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded){
//            NSLog(@"Success saving test object.");
//        } else {
//            NSLog(@"Failed to save test object. Error: %@",error.localizedDescription);
//        }
//    }];
//    PFQuery *testQuery = [PFQuery queryWithClassName:@"TestObject"];
//
//    [testQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"%@",error.localizedDescription);
//        } else {
//            NSLog(@"Query Results: %@",objects);
//        }
//    }];
//
//    //Deleting a PFObject from PFDB
//    [testObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Successfully deleted the testObject.");
//        } else {
//            NSLog(@"Failed to delete the testObject. Error:  %@",error.localizedDescription);
//        }
//    }];


@end
