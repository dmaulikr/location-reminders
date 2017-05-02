//
//  AddReminderViewControlla.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/2/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "AddReminderViewControlla.h"

@interface AddReminderViewControlla ()
@property (weak, nonatomic) IBOutlet UITextField *reminderName;
@property (weak, nonatomic) IBOutlet UITextField *reminderRadius;

@end

@implementation AddReminderViewControlla

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Inside of AddReminderViewControlla%@",self.annotationTitle);
    NSLog(@"Coordinates: %f, %f",self.coordinate.latitude, self.coordinate.longitude);
    // Do any additional setup after loading the view.
}



@end
