//
//  ViewController.m
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "ViewController.h"
#import "Promotion.h"
#import "Data.h"
#import "PListParser.h"

@interface ViewController ()
//properties
@end

@implementation ViewController

#pragma mark - UI View Methods

-(void)viewWillAppear:(BOOL)animated    {
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[Data sharedInstance] createPromotionDict]; //Shared DataDictionary
    [[Data sharedInstance] createPromotionArray]; //Shard Array
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)promotionButtonPressed:(UIButton *)sender {
    NSLog(@"Promotions Button Pressed");
    [self performSegueWithIdentifier:@"GoToPromotions" sender:self];
}
- (IBAction)playButtonPressed:(UIButton *)sender {
    NSLog(@"Play Button Pressed");
}
- (IBAction)infoButtonPressed:(UIButton *)sender {
    NSLog(@"Info Button Presssed: Temporarily Using to show TimesUp Screen");
}
- (IBAction)termsButtonPressed:(UIButton *)sender {
    NSLog(@"Terms Button Pressed");
}

@end
