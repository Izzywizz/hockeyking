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
@property (nonatomic, strong) NSMutableArray *promotionsArray;

@property int score;// Test to see whether Swift can see variable

+(instancetype) sharedInstance;
-(void) createPromotionDict;
-(void) createPromotionArray;
@end
