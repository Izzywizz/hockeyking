//
//  PromotionsTableViewController.m
//  vouchking
//
//  Created by Izzy on 21/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "PromotionsTableViewController.h"
#import "Data.h"
#import "PromotionTableCell.h"

@interface PromotionsTableViewController()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PromotionsTableViewController

#pragma mark - UI TableView Methods
-(void)viewWillAppear:(BOOL)animated    {
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Promotion Count: %lu",(unsigned long)[Data sharedInstance].promotionsDict.count);
    [self setupTable];
}

#pragma mark - Helper Methods
-(void) setupTable  {
    self.tableView.allowsSelectionDuringEditing=YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 258;
}

#pragma mark - TableView <Delgate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Row: %ld", (long)indexPath.row);
}

#pragma mark - TableView DataSource Delegates
// Need to pull in data count from DataShared Instance
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    
    return [Data sharedInstance].promotionsDict.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return [self promotionCellAtIndex:indexPath];
}

#pragma mark - Custom Cell Method Creation
-(PromotionTableCell *) promotionCellAtIndex: (NSIndexPath *) indexPath {
    
    NSString *reuseCellID = @"PromotionCell";
    NSString *nibName =@"PromotionTableCell";
    
    [self.tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:reuseCellID];
    PromotionTableCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseCellID forIndexPath:indexPath];
    
    return cell;
}

@end
