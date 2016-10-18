//
//  PListParser.h
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PListParser : NSObject

@property (strong, nonatomic) NSArray *plistArray;

-(NSArray *) readPlistValuesFromPlist: (NSString *) plistName;
-(void) createPromotionDict: (NSDictionary*) dict;

@end
