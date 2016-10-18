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

@end

@implementation ViewController

#pragma mark - UI View Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [[Data sharedInstance] createPromotionDict];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
