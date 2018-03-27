//
//  PListParser.m
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "PListParser.h"

@implementation PListParser

#pragma mark - Plist Methods

/** Reads in a generic plist and parses the data inside the plist which is stored in the following format:
 Array (parent) -> dictionary, so it is an array of dictionary values*/
-(NSArray *) readPlistValuesFromPlist: (NSString *) plistName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:plistPath];
}

@end
