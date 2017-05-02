//
//  ViewController.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/1/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "ViewControlla.h"
#import "CustomMKPinAnnotationView.h"


@import Parse;
@import MapKit;


@interface ViewControlla () <MKMapViewDelegate>


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewControlla
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
            [self locationPressed:43.8791 AndLongitude:-103.4591];
            [self setCustomAnnotationsWithTitle:@"Mount Rushmore" andLatitude:43.8791 AndLongitude:-103.4591];
            break;
        case 1:
            NSLog(@"Selected Hollywood");
            [self locationPressed:34.0928 AndLongitude:-118.3287];
            [self setCustomAnnotationsWithTitle:@"Hollywood" andLatitude:34.0928 AndLongitude:-118.3287];
            break;
        case 2:
            NSLog(@"Selected Eiffel Tower");
            [self locationPressed:48.8584 AndLongitude:2.2945];
            [self setCustomAnnotationsWithTitle:@"Eiffel Tower" andLatitude:48.8584 AndLongitude:2.2945];
        default:
            break;
            
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPermissions];
    self.coordinateSet = [[NSMutableSet alloc]init];
    self.mapView.delegate = self;
    [[self mapView] setShowsUserLocation:YES];
}


#pragma MapKit helper methods
-(void)requestPermissions {
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestAlwaysAuthorization];
    
}

-(void)locationPressed:(CGFloat)latitude AndLongitude:(CGFloat)longitude{

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
        annotation.coordinate = coordinates;
        annotation.title = title;
        [self.mapView addAnnotation:annotation];
    }
    [self.mapView selectAnnotation:annotation animated:YES];
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    NSLog(@"Inside of viewForAnnotation:");
    CustomMKPinAnnotationView *myAnnotationView = (CustomMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation"];
    if (!myAnnotationView){
        myAnnotationView = [[CustomMKPinAnnotationView alloc] initWithTitle:annotation.title withAnnotation:annotation];
    }
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
