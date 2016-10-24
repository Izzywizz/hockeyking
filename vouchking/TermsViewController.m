//
//  TermsViewController.m
//  vouchking
//
//  Created by Izzy on 24/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController()


@end

@implementation TermsViewController

-(void)viewDidLoad  {
    NSLog(@"Terms Loaded");
}

#pragma mark - ScrollView Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //get refrence of vertical indicator
    UIImageView *verticalIndicator = ((UIImageView *)[scrollView.subviews objectAtIndex:(scrollView.subviews.count-1)]);
    //set color to vertical indicator
    [verticalIndicator setBackgroundColor:[UIColor redColor]];
    //get refrence of horizontal indicator
    UIImageView *horizontalIndicator = ((UIImageView *)[scrollView.subviews objectAtIndex:(scrollView.subviews.count-2)]);
    //set color to horizontal indicator
    [horizontalIndicator setBackgroundColor:[UIColor blueColor]];
}

#pragma mark - Action Methods
- (IBAction)termsButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
