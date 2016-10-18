//
//  Data.m
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "Data.h"

@implementation Data

/** Creates a Singleton pattern/object that brings back a shared instance of the promotional data*/
+(instancetype) sharedInstance  {
    static Data *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[Data alloc] init];
    });
    return sharedInstance;
}

@end
