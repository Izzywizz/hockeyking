//
//  Promotion.m
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "Promotion.h"
//#import <objc/runtime.h>



@implementation Promotion

/** Create a promotion object by taking in a dictionary and assigning the values assocaited the key*/
-(Promotion*)initWithDict:(NSDictionary*)dict   {
    if (self)
    {
        self.promotionId = [dict valueForKey:@"promotionId"];
        self.totalPoints = [dict valueForKey:@"totalPoints"];
        self.currentRank = [dict valueForKey:@"currentRank"];
        self.totalUsers = [dict valueForKey:@"totalUsers"];
        self.expiryEpoch = [dict valueForKey:@"expiryEpoch"];
        self.promotionDescription = [dict valueForKey:@"promotionDescription"];
        self.pointsEarned = [dict valueForKey:@"pointsEarned"];
        self.promotionNotes = [dict valueForKey:@"promotionNotes"];
        self.totalPromotionsAvailable = [dict valueForKey:@"totalPromotionsAvailable"];
        self.businessName = [dict valueForKey:@"businessName"];
        self.twitter = [dict valueForKey:@"twitter"];
        self.facebook = [dict valueForKey:@"facebook"];
        self.website = [dict valueForKey:@"website"];
        self.gameSummaryLogo = [UIImage imageNamed: [dict valueForKey:@"gameSummaryLogo"]];
        self.businessLogo = [UIImage imageNamed: [dict valueForKey:@"businessLogo"]];
        self.havePointsBeenEarned = [[dict valueForKey:@"havePointsBeenEarned"] boolValue];
    }
    
    return self;
}

/*
-(Promotion*)populatePromotion:(Promotion*)p
{
    @autoreleasepool {
        unsigned int numberOfProperties = 0;
        objc_property_t *propertyArray = class_copyPropertyList([self class], &numberOfProperties);
        for (NSUInteger i = 0; i < numberOfProperties; i++) {
            objc_property_t property = propertyArray[i];
            
            NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
            NSLog(@"Property %@ Value: %@", name, [self valueForKey:name]);
            
            NSString *selString = [NSString stringWithFormat:@"set%@", [name capitalizedString]];
            
            SEL s = NSSelectorFromString(selString);
            
            [p performSelector:s withObject:[self valueForKey:name]];
            
            
        }
        free(propertyArray);
    }
        
    return p;
}
 */

@end
