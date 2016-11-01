//
//  CustomNavigationController.m
//  vouchking
//
//  Created by Izzy on 24/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController()

@property UINavigationController *navigationController;

@end

@implementation CustomNavigationController

/** 
 This method returns a UIView that can be used to include an image and text, side by side within the navigation controller title, creating this effect:
 [Image] [Titile Text]
*/
-(UIView *) setupNavigationControllerWithImage: (NSString *) imageName AndTitle: (NSString *) title {
    UIView *navView = [UIView new];

    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later, create the label and view that will hold the image/ text together
        UILabel *label = [UILabel new];
        label.text = [NSString stringWithFormat:@"%@   ",title];
        label.textColor = [UIColor whiteColor];
        
        //font needs to be dynamic, at this moment it is hardcoded for the custom font required by Andy Designs
        [label setFont:[UIFont fontWithName:@"LuckiestGuy-Regular" size:16]];
        [label sizeToFit];
        label.center = navView.center;
        label.textAlignment = NSTextAlignmentCenter;
        
        //create imageView, ensure that the aspect ratio of the image doesnt overlap the image
        UIImageView* img = [[UIImageView alloc] initWithImage:[UIImage imageNamed: imageName]];
        // To maintain the image's aspect ratio:
        CGFloat imageAspect =img.image.size.width/img.image.size.height;
        // Setting the image frame so that it's immediately before the text:
        img.frame = CGRectMake(label.frame.origin.x-label.frame.size.height*imageAspect, label.frame.origin.y, label.frame.size.height*imageAspect, label.frame.size.height);
        img.contentMode = UIViewContentModeScaleAspectFit;
        
        // Add both the label and image view to the navView
        [navView addSubview:label];
        [navView addSubview:img];
        [navView sizeToFit];

    }
    return navView;
}
@end
