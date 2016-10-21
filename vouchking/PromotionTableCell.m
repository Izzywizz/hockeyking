//
//  PromotionTableViewCell.m
//  vouchking
//
//  Created by Izzy on 21/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "PromotionTableCell.h"

@implementation PromotionTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureCell
{
    UIImageView *iv = (UIImageView*) [self viewWithTag:31];
    UILabel *descriptionLabel = (UILabel*)[self viewWithTag:100];
    iv.image = _promotion.gameSummaryLogo;
    descriptionLabel.text = _promotion.promotionDescription;
}

@end
