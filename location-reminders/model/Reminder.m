//
//  Reminder.m
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/3/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import "Reminder.h"

@implementation Reminder

//Dynamic defers the creation of the setters and getters to an another class at runtime
@dynamic name;

@dynamic location;

@dynamic radius;

+(void)load{
    [super load];
    [self registerSubclass];
}

+(NSString *)parseClassName{
    //Specifies the name of the entity on the parse dashboard.
    return @"Reminder";
}
@end
