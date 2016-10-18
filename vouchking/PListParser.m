//
//  PListParser.m
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "PListParser.h"
#import "Promotion.h"

@interface PListParser()

@property (strong, nonatomic) Promotion *promotion;
@end

@implementation PListParser

#pragma mark - plist Methods

/** Reads in a generic plist and parses the data inside the plist which is stored in the following format:
 Array (parent) -> dictionary, so it is an array of dictionary values*/
-(NSArray *) readPlistValuesFromPlist: (NSString *) plistName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    _plistArray = [NSArray arrayWithContentsOfFile:plistPath];

//    NSLog(@"Array: %@", _plistArray);
    return _plistArray;
}

#pragma mark - Promotion Methods  

-(void) createPromotionDict: (NSDictionary*) dict  {
    
    dict = [NSDictionary dictionaryWithDictionary:[_plistArray objectAtIndex:0]];
    NSLog(@"Dictionary: %@", dict);
}

@end
