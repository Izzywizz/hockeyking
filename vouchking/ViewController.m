//
//  ViewController.m
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "ViewController.h"
#import "Promotion.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - UI View Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    Promotion *starbucks = [[Promotion alloc] init];
    starbucks = [self createPromotionTestObject];
    NSLog(@"StarBuck: %@", starbucks);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Functions
-(Promotion *) createPromotionTestObject    {
    Promotion *promotion = [[Promotion alloc] init];
    promotion.promotionId = @123;
    promotion.totalPoints = @7;
    promotion.currentRank = @2;
    promotion.totalUsers = @600;
    promotion.expiryEpoch = @1476780997;
    promotion.promotionDescription = @"This is a promotion";
    promotion.pointsEarned = @77;
    promotion.promotionNotes = @"Notes on promtions man";
    promotion.totalPromotionsAvailable = @9000;
    promotion.businessName = @"KFC";
    promotion.twitter = [NSURL URLWithString:@"http://www.twitter.com"] ;
    promotion.facebook = [NSURL URLWithString:@"http:www.facebook.com"];
    promotion.website = [NSURL URLWithString:@"Http:no.co.uk"];
    
    return promotion;
}

@end
