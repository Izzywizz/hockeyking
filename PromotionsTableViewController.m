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
#import "UnderlayNavigationBar.h"

@interface PromotionsTableViewController()<UITableViewDelegate, UITableViewDataSource>

@property NSArray *promoKeysArray;

@end

@implementation PromotionsTableViewController

#pragma mark - UI TableView Methods
-(void)viewWillAppear:(BOOL)animated    {
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"Promotion Count: %lu",(unsigned long)[Data sharedInstance].promotionsDict.count);
    _promoKeysArray = [[Data sharedInstance].promotionsDict allKeys];
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

-(void) setupNavigationController   {
    if (self.navigationController == nil) {
        return;
    }
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later, create the label and view that will hold the image/ text together
        UIView *navView = [UIView new];
        UILabel *label = [UILabel new];
        label.text = @" PROMOTIONS STORE";
        label.textColor = [UIColor whiteColor];
        [label setFont:[UIFont fontWithName:@"LuckiestGuy-Regular" size:16]];
        [label sizeToFit];
        label.center = navView.center;
        label.textAlignment = NSTextAlignmentCenter;

        //create imageView, ensure that the aspect ratio of the image doesnt overlap the image
        UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"30.png"]];
        // To maintain the image's aspect ratio:
        CGFloat imageAspect =img.image.size.width/img.image.size.height;
        // Setting the image frame so that it's immediately before the text:
        img.frame = CGRectMake(label.frame.origin.x-label.frame.size.height*imageAspect, label.frame.origin.y, label.frame.size.height*imageAspect, label.frame.size.height);
        img.contentMode = UIViewContentModeScaleAspectFit;
        
        // Add both the label and image view to the navView
        [navView addSubview:label];
        [navView addSubview:img];
        
        // Set the navigation bar's navigation item's titleView to the navView
        self.navigationItem.titleView = navView;
        
        //set the colour of nav bar
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:31.0/255.0 green:84.0/255.0 blue:118.0/255.0 alpha:1.0];
                [self.navigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        self.navigationController.navigationBar.translucent = NO;
        
        [navView sizeToFit];
    }
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
    Promotion *p = [[Data sharedInstance].promotionsDict valueForKey:[_promoKeysArray objectAtIndex:indexPath.row]]; //Access the object associated the ID
    cell.promotion = p; //reference the object associated with the Cell
    
    [cell configureCell];
    
    return cell;
}

#pragma mark - Action Method
- (IBAction)backButtonPressed:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
