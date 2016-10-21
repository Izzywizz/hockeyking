//
//  PromotionTableViewCell.h
//  vouchking
//
//  Created by Izzy on 21/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *promotionsBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *promotionTimeLeft;
@property (weak, nonatomic) IBOutlet UILabel *promotionDescription;
@property (weak, nonatomic) IBOutlet UILabel *promotionPointsNeeded;
@property (weak, nonatomic) IBOutlet UILabel *promotionsAvailable;

@end
