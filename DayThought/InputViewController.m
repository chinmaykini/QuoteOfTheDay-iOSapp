//
//  InputViewController.m
//  DayThought
//
//  Created by Chinmay Kini on 4/27/15.
//  Copyright (c) 2015 com.ck. All rights reserved.
//

#import "InputViewController.h"
#import "Parse/Parse.h"

@interface InputViewController ()

@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title                               = @"Input";
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
- (IBAction)onInput:(id)sender {
    
    PFObject *thought   = [PFObject objectWithClassName:@"ThoughtForTheDay"];
    thought[@"thought"] = self.thoughtInputFeild.text;
    [thought saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Sent:  %@ ", self.thoughtInputFeild.text);
            self.thoughtInputFeild.text = @"";
            self.resultLabel.text = @"Success";
    
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"Error Sending :  %@  Error: %@", self.thoughtInputFeild.text, errorString);
            self.resultLabel.text = @"Error";

        }
    }];
}

@end
