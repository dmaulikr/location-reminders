//
//  ViewController.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/1/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "ViewController.h"

@import Parse;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    
    testObject[@"testName"] = @"Castro";
    
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"Success saving test object.");
        } else {
            NSLog(@"Failed to save test object. Error: %@",error.localizedDescription);
        }
    }];
    PFQuery *testQuery = [PFQuery queryWithClassName:@"TestObject"];
    
    [testQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        } else {
            NSLog(@"Query Results: %@",objects);
        }
    }];
    
    //Deleting a PFObject from PFDB
    [testObject deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Successfully deleted the testObject.");
        } else {
            NSLog(@"Failed to delete the testObject. Error:  %@",error.localizedDescription);
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
