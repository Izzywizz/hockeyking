//
//  OverlayView.m
//  Why Go Solo
//
//  Created by Izzy on 05/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "OverlayView.h"

@implementation OverlayView

#pragma mark - View Methods

-(void)awakeFromNib {
    [self performSelector:@selector(performAnimation) withObject:nil afterDelay:2.0];
}

#pragma mark - Class Methods
+ (id)overlayView
{
    OverlayView *overlayView = [[[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:nil options:nil] lastObject];
    // make sure customView is not nil or the wrong class!
    if ([overlayView isKindOfClass:[OverlayView class]])
        return overlayView;
    else
        return nil;
}

-(void) performAnimation    {
    [self setAlpha:1.0f];
    [UIView animateWithDuration:2.0f animations:^{
        [self setAlpha:0.0f];
    }];
}

@end
