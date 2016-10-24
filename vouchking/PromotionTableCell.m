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

/**There are no references to the properties, they are associated with TAG's via local variables:
 exp, The background image has the tag of 31 which if you notice is the same as the one on the annotated designs and the assests name within the assets folder*/
-(void) configureCell
{
    UIImageView *iv = (UIImageView*) [self viewWithTag:31];
    UILabel *descriptionLabel = (UILabel*)[self viewWithTag:100];
    UILabel *pointsEarned = (UILabel*)[self viewWithTag:90];
    iv.image = _promotion.gameSummaryLogo;
    descriptionLabel.text = _promotion.promotionDescription;
    pointsEarned.text = [NSString stringWithFormat:@"%@/500", _promotion.pointsEarned]; //Totalout is hardset
}

@end
