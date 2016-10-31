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
    UILabel *promotionTimeLeft = (UILabel *)[self viewWithTag:80];
    UILabel *totalPromotionsAvailable = (UILabel *)[self viewWithTag:70];
    
    //Setting up the values/images by referencing the Promotion object
    iv.image = _promotion.gameSummaryLogo;
    descriptionLabel.text = _promotion.promotionDescription;
    //reset points to 0 so that the previous scores are not always showing
    
//    if (_promotion.havePointsBeenEarned == true) {
        pointsEarned.text = [NSString stringWithFormat:@"(%@) %@/500", _promotion.pointsEarned, _promotion.totalPoints]; //Total points Earned is 500 and hardset
//        _promotion.havePointsBeenEarned = false; //set it back to false ie default
//    } else  {
//        pointsEarned.text = [NSString stringWithFormat:@"(0) %@/500", _promotion.totalPoints]; //no points earned for that promotion for that round so keep it at zero
//    }
    promotionTimeLeft.text = [NSString stringWithFormat:@"%@ Left", [self convertToEpochTime:_promotion.expiryEpoch]]; //Calcualtions needed to set whether it is DAys/ Hours
    totalPromotionsAvailable.text = [NSString stringWithFormat:@"%@", _promotion.totalPromotionsAvailable];
}

/** Method that takes the current time and the date set within the Promotion object itself and returns the difference as string
 The grammar format is handle by another method below which takes into account Days/ day or Hours/ hour. 
 The method also account for daylight saving time*/
-(NSString *) convertToEpochTime: (NSNumber *) epochTime    {
    
    NSCalendar *c = [NSCalendar currentCalendar];
    double doubleTime = [epochTime doubleValue];
    NSDate *futureDate = [NSDate dateWithTimeIntervalSince1970:doubleTime];
    NSDate *dateNow = [NSDate date];
    
    NSDateComponents *components = [c components:NSCalendarUnitHour fromDate:dateNow toDate:futureDate options:0];
    NSInteger diff = components.hour;
    if (diff < 24) {
        return  [self isTheTimeLeftInDays:NO andTimeLeft:diff];
    } else  {
        NSDateComponents *components = [c components:NSCalendarUnitDay fromDate:dateNow toDate:futureDate options:0];
        NSInteger diff = components.day;
        return [self isTheTimeLeftInDays:YES andTimeLeft:diff];
    }
}

-(NSString *) isTheTimeLeftInDays:(BOOL) isTimeDifferenceDay andTimeLeft:(NSInteger) timeLeft{
    
    if (isTimeDifferenceDay) {
        if (timeLeft <= 1) {
            return [NSString stringWithFormat:@"%ld Day", (long)timeLeft];
        } else  {
            return [NSString stringWithFormat:@"%ld Days", (long)timeLeft];
        }
    } else  {
        if (timeLeft <= 1) {
            return [NSString stringWithFormat:@"%ld Hour", (long)timeLeft];
        } else  {
            return [NSString stringWithFormat:@"%ld Hours", (long)timeLeft];
        }
    }
}

@end
