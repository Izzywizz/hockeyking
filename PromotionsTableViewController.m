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
#import "CustomNavigationController.h"

@interface PromotionsTableViewController()<UITableViewDelegate, UITableViewDataSource>

@property NSArray *promoKeysArray; //Previously used when the Promotion where Dict

@end

@implementation PromotionsTableViewController

#pragma mark - UI TableView Methods
-(void)viewWillAppear:(BOOL)animated    {
    [self.navigationController setNavigationBarHidden:NO];
    _promoKeysArray = [[Data sharedInstance].promotionsDict allKeys];//PromotionID number assoicated with the Promotion Object
    [self setupTable];
}

-(void) viewDidLoad {
    [self setupNavigationController];
}

#pragma mark - Helper Methods
-(void) setupTable  {
    self.tableView.allowsSelectionDuringEditing=YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 258;
}

/** This method setups up the navigation controller to include text and image side by side */
-(void) setupNavigationController   {
    
    CustomNavigationController *customNavBar = [[CustomNavigationController alloc] init];
    // Set the custom NavgiationView returned by the methodto the titleView.
    self.navigationItem.titleView =  [customNavBar setupNavigationControllerWithImage:@"30.png" AndTitle:@"PROMOTIONS STORE"];
    //set the colour of the whole nav bar to that blue suggested in the design
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:31.0/255.0 green:84.0/255.0 blue:118.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark - TableView <Delgate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Row: %ld", (long)indexPath.row);
}

#pragma mark - TableView DataSource Delegates
// Need to pull in data count from DataShared Instance
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section    {
    
//    return [Data sharedInstance].promotionsDict.count;
    return [Data sharedInstance].promotionsArray.count;
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
    Promotion *p = [[Data sharedInstance].promotionsArray objectAtIndex:indexPath.row];
//    Promotion *p = [[Data sharedInstance].promotionsDict valueForKey:[_promoKeysArray objectAtIndex:indexPath.row]]; //Access the object associated the ID
    cell.promotion = p; //reference the object associated with the Cell
    
    [cell configureCell];
    
    return cell;
}

#pragma mark - Action Method
- (IBAction)backButtonPressed:(UIBarButtonItem *)sender {
    if (sender.tag == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}






@end
