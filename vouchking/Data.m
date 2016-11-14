//
//  Data.m
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "Data.h"
#import "Promotion.h"
#import "PListParser.h"
#import "NSObject+logProperties.h"

@implementation Data

/** 
 Creates a Singleton pattern/object that brings back a shared instance of the promotional data so it can be used thorughtout the application
 */
+(instancetype) sharedInstance  {
    static Data *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[Data alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Promotion Methods

/** 
 Create a promotion object from a dictionary of values: the key/value pairs are obtained from the PlistParser which returns an Array and that
 array contains a dictionary of key/value items that make up a promotion object. These are then passed in to the Promotion custom initializer
 that takes in a dictionary which is the same one that is being passed in from the plist and creates this Promotion object.
 This newly created Promotion Obj is then added to the data dict (which is persistant across the app) and the ID tag of the promotion is set as 
 its key and the value is the actual promotion object.
 */
-(void) createPromotionDict  {
    
    _promotionsDict = [NSMutableDictionary new];
    
    for (NSDictionary *d in [[PListParser new] readPlistValuesFromPlist:@"promotions"]) {
        Promotion *promotionsObj = [[Promotion alloc]initWithDict:d];
        [_promotionsDict setObject:promotionsObj forKey:[NSString stringWithFormat:@"%@", promotionsObj.promotionId]];
        [promotionsObj logProperties];
    }
    NSLog(@"Promotions Dictionary: %@", _promotionsDict);
}


/**
 This method recreates the same functionality as PromsDict however each promotionObject created is added to an array rather than a dictionary.
 The array is populated with the information from the plist, thus we are able to reference the data anywhere from within the app so that it always peristent 
 It also is easier to update the object because an array is an ordered list , you just reference the specific number/ index and replaceObject 
 */
-(void) createPromotionArray  {
    
    _promotionsArray = [NSMutableArray new];
    
    for (NSDictionary *d in [[PListParser new] readPlistValuesFromPlist:@"promotions"]) {
        Promotion *promotionsObj = [[Promotion alloc]initWithDict:d];
        [_promotionsArray addObject:promotionsObj];
        [promotionsObj logProperties];
    }
    NSLog(@"Promotions Array: %@", _promotionsArray);
}


@end
