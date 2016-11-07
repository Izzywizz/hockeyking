//
//  PromotionTableViewCell.m
//  vouchking
//
//  Created by Izzy on 21/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "PromotionTableCell.h"
#import "UILabel+FormattedText.h"


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
    
    if (_promotion.negativeLimitReached == true) {
        NSLog(@"Confirmed Negatived Limit Reached");
        pointsEarned.text = [NSString stringWithFormat:@"(Limit Reached) %@/500", _promotion.totalPoints]; //Total points Earned is 500 and hardset
    } else  {
        pointsEarned.text = [NSString stringWithFormat:@"(%@) %@/500", _promotion.totalPointsEarnedPerRound, _promotion.totalPoints]; //Total points Earned is 500 and hardset
    }
    [self setPostiveNegativeColours:pointsEarned];
    promotionTimeLeft.text = [NSString stringWithFormat:@"%@ Left", [self convertToEpochTime:_promotion.expiryEpoch]]; //Calcualtions needed to set whether it is DAys/ Hours
    totalPromotionsAvailable.text = [NSString stringWithFormat:@"%@", _promotion.totalPromotionsAvailable];
}

/**
 Deciedes what colour the value should be for the label that clearly repsents a changge in the score of the user pointsEarned for that round (NOT the total), a blue colour is used for positive numbers,
 the red colour for a negative score and green for neutral.
 The UILabel uses a custom extension class UILabel+FormattedText to extend functionality and easily allow the text colour changed at a whim
 */
-(void) setPostiveNegativeColours: (UILabel*) pointsEarned   {
    if ([_promotion.totalPointsEarnedPerRound intValue] > 0) {
        [pointsEarned setTextColor:[UIColor blueColor] fromOccurenceOfString:@"(" toOccurenceOfString:@" "];
    } else if ([_promotion.totalPointsEarnedPerRound intValue] < 0)    {
        [pointsEarned setTextColor:[UIColor redColor] fromOccurenceOfString:@"(" toOccurenceOfString:@" "]; //uses extension class UILabel to extend functionality
    } else  {
        [pointsEarned setTextColor:[UIColor blackColor] fromOccurenceOfString:@"(" toOccurenceOfString:@" "]; //uses extension class UILabel to extend functionality
    }
}


/**
 This method takes the current time and the date set within the Promotion object itself and returns the difference as string
 The grammar format is handle by another method below which takes into account Days/ day or Hours/ hour.
 The method also account for daylight saving time
 */
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


/**
 Ensures that the correct grammar is used for the relevant days/ day and hours/ hour depending on the amount time left, for example
 It wouldn't be appropiate to say 1 hours left, it would be better to say 1 hour left. This is essentially what this method does.
 */
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
