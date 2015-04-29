//
//  ThoughtViewController.m
//  DayThought
//
//  Created by Chinmay Kini on 4/27/15.
//  Copyright (c) 2015 com.ck. All rights reserved.
//

#import "ThoughtViewController.h"
#import "Parse/Parse.h"
#import "InputViewController.h"
#import "UIImageView+AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"

@interface ThoughtViewController ()

@property ( nonatomic, strong ) CLLocation *currentLocation;

@end

@implementation ThoughtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // location
    [[LocationManager instance] addLocationObserver:self block:^(NSNotification *note) {
        CLLocation *location = note.userInfo[@"location"];
        NSLog(@"VC location lat : %f location lon : %f", location.coordinate.latitude, location.coordinate.longitude);
        self.currentLocation = location;
    }];

    
    self.navigationController.navigationBar.barTintColor    = [UIColor colorWithRed:0.40196557852924675 green:0.77594807697599411 blue:1 alpha:1];
    self.navigationController.navigationBar.tintColor       = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent     = YES;
    self.navigationItem.title                               = @"Quote";
    
    //  button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Store" style:UIBarButtonItemStyleDone target:self action:@selector(onStore)];
    
    self.counter = -1;
    self.photoCounter = -1;
    [self refreshThoughts];
    [self getPhotosFlickr];
    self.thoughtFeild.text = self.thoughts[0];
    
    
    
    self.inspireMeButton.enabled = NO;
    
    
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector: @selector(refreshThoughts) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) refreshThoughts{

    PFQuery *query = [PFQuery queryWithClassName:@"ThoughtForTheDay"];

    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            self.thoughts = [NSMutableArray array];
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object[@"thought"]);
                [self.thoughts addObject:object[@"thought"]];
            }

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (IBAction)onInspireMe:(id)sender {
    

    
    self.counter++;
    self.photoCounter++;
    
    if(self.counter == self.thoughts.count-1){
        self.counter = 0;
    }
    self.thoughtFeild.text = self.thoughts[self.counter];
    
    if(self.photoCounter == self.photoUrls.count-1){
        self.photoCounter = 0;
    }
    [self.flickrImagePoster setImageWithURL:[NSURL URLWithString:self.photoUrls[self.photoCounter]]];
    
    NSLog(@"%@", self.photoUrls);
    
    [UIView animateWithDuration:0.8 animations:^{
        self.inspireMeButton.transform = CGAffineTransformMakeScale(2, 2);
        self.inspireMeButton.transform = CGAffineTransformMakeScale(1, 1);
        self.thoughtFeild.transform = CGAffineTransformMakeScale(2, 2);
        self.thoughtFeild.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [self.inspireMeButton setTitle:@"Inspired" forState:UIControlStateDisabled];
    }];
}

-(void) onStore {
    
    InputViewController *ivc = [[InputViewController alloc] init];
    [self.navigationController pushViewController:ivc animated:YES];
}

- (void)getPhotosFlickr {
    
    
    NSString *urlPostFix = [NSString stringWithFormat:@"&lat=%f&lon=%f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
    
    NSString *urlPreFix = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=410b6b03bd36c22f0f96322e8ec8a298&tags=bridge,treyratcliff&sort=interestingness-desc&privacy_filter=1&accuracy=11&safe_search=1&content_type=1&radius=20&radius_units=mi&format=json&nojsoncallback=1";

    NSString *urlStr = [urlPreFix stringByAppendingString:urlPostFix];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
    
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        NSLog(@"%@",responseDictionary);
        NSArray *flickrData = responseDictionary[@"photos"];
        NSArray *photos = [flickrData valueForKeyPath:@"photo"];
        self.photoUrls = [[NSMutableArray alloc] init];

        for(NSDictionary *dictionary in photos){
            
            NSString *flickrUrl = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_b.jpg", dictionary[@"farm"], dictionary[@"server"], dictionary[@"id"], dictionary[@"secret"]];
            NSLog(@"photo url : %@", flickrUrl);
            [self.photoUrls addObject:flickrUrl];
        }
        self.inspireMeButton.enabled = YES;
    }];
}


@end
