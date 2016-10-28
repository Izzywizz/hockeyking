//
//  TimesUpViewController.m
//  vouchking
//
//  Created by Izzy on 25/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TimesUpViewController.h"
#import "PromotionsTableViewController.h"

@interface TimesUpViewController ()

@end

@implementation TimesUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Times Up");
    [self performSelector:@selector(performAnimation) withObject:nil afterDelay:3.0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Functions

- (void) performAnimation
{
    PromotionsTableViewController *nextView =[self.storyboard instantiateViewControllerWithIdentifier:@"PromotionsTableViewController"];
    nextView.backButton.image = [UIImage imageNamed:@""];
    nextView.backButton.title = @"Done";
    nextView.backButton.tag = 1;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:nextView animated:NO];
}

@end
