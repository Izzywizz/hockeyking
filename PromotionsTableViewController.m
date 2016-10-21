//
//  PromotionsTableViewController.m
//  vouchking
//
//  Created by Izzy on 21/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "PromotionsTableViewController.h"
#import "Data.h"
@interface PromotionsTableViewController()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PromotionsTableViewController

#pragma mark - UI TableView Methods
-(void)viewWillAppear:(BOOL)animated    {
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Promotion Count: %lu",(unsigned long)[Data sharedInstance].promotionsDict.count);
}

#pragma mark - TableView DataSource Delegates
// Need to pull in data count from DataShared Instance
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
@end
