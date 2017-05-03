//
//  ViewController.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/1/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "HomeViewControlla.h"

#import "AddReminderViewControlla.h"

#import "LocationControllaDelegate.h"

#import "CustomMKPinAnnotationView.h"

#import "LocationControlla.h"


@import Parse;
@import MapKit;


@interface HomeViewControlla () <MKMapViewDelegate, LocationControllaDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation HomeViewControlla
- (IBAction)dropPin:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [sender locationInView:self.mapView];
        
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:point toCoordinateFromView:self.view];
        
        NSLog(@"The coordinate of tapped location: Lat:%f Lon: %f", coordinate.latitude, coordinate.longitude);
        
        
        [self setCustomAnnotationsWithTitle:@"Reminder" andLatitude:coordinate.latitude AndLongitude:coordinate.longitude];

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
            [self setLocationWithLatitude:43.8791 AndLongitude:-103.4591];
            [self setCustomAnnotationsWithTitle:@"Mount Rushmore"
                                    andLatitude:43.8791
                                   AndLongitude:-103.4591];
            break;
        case 1:
            [self setLocationWithLatitude:34.0928 AndLongitude:-118.3287];
            [self setCustomAnnotationsWithTitle:@"Hollywood"
                                    andLatitude:34.0928
                                   AndLongitude:-118.3287];
            break;
        case 2:
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
    [[self navigationItem] setTitle:@"Location Reminders"];
    [[self mapView] setDelegate: self];
    
    [[self mapView] setShowsUserLocation:YES];

    [LocationControlla shared].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reminderSavedToParse:) name:@"ReminderSavedToParse" object:nil];
}

-(void)reminderSavedToParse:(id)sender{
    NSLog(@"New reminder saved to Parse: %@",sender);
}

#pragma LocationControllaDelegate

-(void)locationControllaUpdatedLocation:(CLLocation *)location{
    [self setLocationWithLatitude:location.coordinate.latitude AndLongitude:location.coordinate.longitude];
    NSLog(@"locationController: lat: %2f lon: %2f",location.coordinate.latitude, location.coordinate.longitude);
}


#pragma MapKit helper methods
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    if ([[segue identifier] isEqualToString:@"AddReminderViewControlla"] && [sender isKindOfClass:[MKAnnotationView class]]) {
        CustomMKPinAnnotationView *annotationView = (CustomMKPinAnnotationView *)sender;
        AddReminderViewControlla *destinationController = (AddReminderViewControlla *)segue.destinationViewController;
        [destinationController setCoordinate:annotationView.annotation.coordinate];
        [destinationController setAnnotationTitle:annotationView.annotation.title];
        
        [destinationController setTitle:@"New Location"];
        
        //create a weak connection
        //This is used only when refencing self in the completion block; Avoid retain cycle (circular reference)
        __weak typeof(self) bruce = self;
        destinationController.completion = ^(MKCircle *circle) {
            __strong typeof(bruce) hulk = bruce;
            [[hulk mapView] removeAnnotation:annotationView.annotation];
            [[hulk mapView] addOverlay:circle];
            
        };
    }
}


#pragma override dealloc as part of NSNotificationCenter

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReminderSavedToParse" object:nil];
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


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"The callout button associated with %@", view.annotation.title);
    [self performSegueWithIdentifier:@"AddReminderViewControlla" sender:view];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
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

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:overlay];
    
    [renderer setStrokeColor:[UIColor blueColor]];
    [renderer setFillColor:[UIColor redColor]];
    [renderer setAlpha:0.5];
    return renderer;
}


@end
