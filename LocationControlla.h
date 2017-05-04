//
//  LocationController.h
//  location-reminders
//
//  Created by Elyanil Liranzo Castro on 5/2/17.
//  Copyright © 2017 Elyanil Liranzo Castro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationControllaDelegate.h"
@import CoreLocation;

@interface LocationControlla : NSObject
@property (weak, nonatomic) id <LocationControllaDelegate> delegate;

+(instancetype)shared;
-(void)requestPermissions;

@end
