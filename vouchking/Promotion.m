//
//  Promotion.m
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "Promotion.h"

@implementation Promotion

/** Create a promotion object  */
-(Promotion*)initWithDict:(NSDictionary*)dict   {
    if (self)
    {
        self.promotionId = [dict valueForKey:@"promotionId"];
        self.totalPoints = [dict valueForKey:@"totalPoints"];
        self.currentRank = [dict valueForKey:@"currentRank"];
        self.totalUsers = [dict valueForKey:@"expiryEpoch"];
        self.promotionDescription = [dict valueForKey:@"promotionDescription"];
        self.pointsEarned = [dict valueForKey:@"pointsEarned"];
        self.promotionNotes = [dict valueForKey:@"promotionNotes"];
        self.totalPromotionsAvailable = [dict valueForKey:@"totalPromotionsAvailable"];
        self.businessName = [dict valueForKey:@"businessName"];
        self.twitter = [dict valueForKey:@"twitter"];
        self.facebook = [dict valueForKey:@"facebook"];
        self.website = [dict valueForKey:@"website"];
    }
    
    return self;

}


@end
