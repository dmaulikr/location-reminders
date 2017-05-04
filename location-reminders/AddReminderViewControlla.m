//
//  AddReminderViewControlla.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/2/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "AddReminderViewControlla.h"
#import "Reminder.h"

@interface AddReminderViewControlla ()
@property (weak, nonatomic) IBOutlet UITextField *reminderName;
@property (weak, nonatomic) IBOutlet UITextField *reminderRadius;

@end

@implementation AddReminderViewControlla

- (void)viewDidLoad {
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitButtonTapped)];
    
    [[self navigationItem] setRightBarButtonItem:submitButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}





-(void)submitButtonTapped{
    if ([self.reminderName hasText] && [self.reminderRadius hasText]) {
        [self createReminder];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
}


-(void)createReminder{
    Reminder *reminder = [Reminder object];
    
    reminder.name = [[self reminderName]text];
    reminder.location = [PFGeoPoint geoPointWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    reminder.radius = [self toNumberFromString:[[self reminderRadius] text]];
    

    [reminder saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Reminder successfully saved: title %@",reminder.name);
            NSLog(@"Reminder successfully saved: geopoint lat:%f lon:%f",reminder.location.latitude,reminder.location.longitude);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ReminderSavedToParse" object:nil];
        } else {
            NSLog(@"Failed to save reminder: Error %@",error.localizedDescription);
        }
        if ([self completion]) {
            CGFloat radius = [[reminder radius] floatValue] ; //for lab; radius comes from user
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:self.coordinate radius:radius];
            self.completion(circle);
        }
    }];
}

#pragma NSString to NSNumber formatter

-(NSNumber *)toNumberFromString:(NSString *)string{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [numberFormatter numberFromString:string];
}

@end
