//
//  Data.h
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject

@property (nonatomic, strong) NSMutableDictionary *promotionsDict;
@property int score;

+(instancetype) sharedInstance;
-(void) createPromotionDict;
@end
