//
//  Promotion.h
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Promotion : NSObject

@property (nonatomic, strong) NSNumber *promotionId;
@property (nonatomic, strong) NSNumber *totalPoints;
@property (nonatomic, strong) NSNumber *currentRank;
@property (nonatomic, strong) NSNumber *totalUsers;
@property (nonatomic, strong) NSNumber *expiryEpoch;
@property (nonatomic, strong) NSString *promotionDescription;
@property (nonatomic, strong) NSNumber *pointsEarned;
@property (nonatomic, strong) NSString *promotionNotes;
@property (nonatomic, strong) NSNumber *totalPromotionsAvailable;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, strong) NSURL *twitter;
@property (nonatomic, strong) NSURL *facebook;
@property (nonatomic, strong) NSURL *website;

-(Promotion*)initWithDict:(NSDictionary*)dict;
//-(Promotion*)populatePromotion:(Promotion*)p; Andy Method to parse data based on the number of properties
@end
