//
//  LocationManager.h
//  DayThought
//
//  Created by Chinmay Kini on 4/28/15.
//  Copyright (c) 2015 com.ck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject

@property ( nonatomic, strong ) CLLocationManager *locationManager;

+ ( LocationManager *)instance;

- (void)addLocationObserver:(id)observer block:(void (^)(NSNotification *note))block;


@end