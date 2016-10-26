//
//  GameSummaryViewController.m
//  vouchking
//
//  Created by Izzy on 26/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "GameSummaryViewController.h"

@interface GameSummaryViewController ()

@end

@implementation GameSummaryViewController

#pragma mark - UIVIew Methods

-(void) viewDidAppear:(BOOL)animated    {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(totalPointsTally:) name:@"FinalScores" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Working out Scores");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Observer Methods

-(void) totalPointsTally: (NSNotification *) notification {
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"Scores Dict: %@", userInfo);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
