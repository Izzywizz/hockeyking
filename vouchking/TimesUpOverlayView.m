//
//  TimesUpOverlayView.m
//  vouchking
//
//  Created by Izzy on 25/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TimesUpOverlayView.h"

@implementation TimesUpOverlayView

#pragma mark - Nib Method
-(void)awakeFromNib {
    NSLog(@"TimesUp nib loaded");
}

#pragma mark - Class Methods
+ (id)createOverlayView
{
    TimesUpOverlayView *overlayView = [[[NSBundle mainBundle] loadNibNamed:@"TimesUpOverlay" owner:nil options:nil] lastObject];
    // make sure customView is not nil or the wrong class!
    if ([overlayView isKindOfClass:[TimesUpOverlayView class]])
        return overlayView;
    else
        return nil;
}


@end
