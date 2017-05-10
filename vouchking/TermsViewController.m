//
//  TermsViewController.m
//  vouchking
//
//  Created by Izzy on 24/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TermsViewController.h"

@interface TermsViewController()
@property (weak, nonatomic) IBOutlet UITextView *termsTextView;
@end

@implementation TermsViewController

#pragma mark - UI View Methods
- (void)viewDidLayoutSubviews {
    [self.termsTextView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - Action Methods
- (IBAction)termsButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
