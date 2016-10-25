//
//  TimesUpViewController.m
//  vouchking
//
//  Created by Izzy on 25/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TimesUpViewController.h"

@interface TimesUpViewController ()

@end

@implementation TimesUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Times Up");
    [self performSelector:@selector(moveToGameSummaryViewController) withObject:nil afterDelay:3.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Functions
-(void) moveToGameSummary   {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"GameSummaryViewController"];
    [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentViewController:vc animated:YES completion:nil];

}
-(void) moveToGameSummaryViewController {
    [self moveToGameSummary];
}

@end
