//
//  LocationManager.m
//  DevicesDemo
//
//  Created by Chinmay Kini on 4/18/15.
//  Copyright (c) 2015 com.ck. All rights reserved.
//

#import "LocationManager.h"


@interface LocationManager () <CLLocationManagerDelegate>

@end

@implementation LocationManager


+ ( LocationManager *)instance {
    
    static LocationManager *locationManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        if(locationManager == nil){
            locationManager = [[LocationManager alloc] init];
            
        }
    });
    
    return locationManager;
}

-(id) init{
    self = [super init];
    
    if(self){
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
    return self;
}

// location functions
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations{
    
    CLLocation *location = [locations lastObject];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kLocationDidUpdate" object:nil userInfo:@{ @"location" : location }];
    
    // get current time, minus 10 mins, and stop updating loaction until u reach the threshogld
    //    NSDate *date = [NSDate date];
    //    [date dateByAddingTimeInterval:-60*10];
    //    if([location.timestamp compare:date] == NSOrderedDescending){
    //        [self.locationManager stopUpdatingLocation];
    //    }
    //
    //    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //
    //    NSLog(@"location : %@", location);
    
    
}


- (void)addLocationObserver:(id)observer block:(void (^)(NSNotification *note))block {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"kLocationDidUpdate" object:nil queue:[NSOperationQueue mainQueue] usingBlock:block];
}

@end
