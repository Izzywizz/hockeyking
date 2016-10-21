//
//  PromotionTableViewCell.h
//  vouchking
//
//  Created by Izzy on 21/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Promotion.h"

@interface PromotionTableCell : UITableViewCell
@property (nonatomic, strong) Promotion *promotion;

-(void) configureCell;

@end
