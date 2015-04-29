//
//  ThoughtViewController.h
//  DayThought
//
//  Created by Chinmay Kini on 4/27/15.
//  Copyright (c) 2015 com.ck. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ThoughtViewController : UIViewController

@property ( strong, nonatomic)  NSMutableArray *thoughts;
@property ( strong, nonatomic)  NSMutableArray *photoUrls;
//@property( nonatomic, assign)  NSInteger *counter;
@property ( assign, nonatomic)  int counter;
@property ( assign, nonatomic)  int photoCounter;
@property (weak, nonatomic) IBOutlet UILabel *thoughtFeild;
@property (weak, nonatomic) IBOutlet UIImageView *flickrImagePoster;
@property (weak, nonatomic) IBOutlet UIButton *inspireMeButton;

@end
