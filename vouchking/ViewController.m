//
//  ViewController.m
//  vouchking
//
//  Created by Izzy on 18/10/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "ViewController.h"
#import "Promotion.h"
#import "Data.h"
#import "PListParser.h"
#import "TimesUpOverlayView.h"

@interface ViewController ()
@property (nonatomic) TimesUpOverlayView *overlayVC;

@end

@implementation ViewController

#pragma mark - UI View Methods

-(void)viewWillAppear:(BOOL)animated    {
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[Data sharedInstance] createPromotionDict]; //Shared Data
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)promotionButtonPressed:(UIButton *)sender {
    NSLog(@"Promotions Button Pressed");
    [self performSegueWithIdentifier:@"GoToPromotions" sender:self];
}
- (IBAction)playButtonPressed:(UIButton *)sender {
    NSLog(@"Play Button Pressed");
}
- (IBAction)infoButtonPressed:(UIButton *)sender {
    NSLog(@"Info Button Presssed");
    [self createTimesUpOverlay];

}
- (IBAction)termsButtonPressed:(UIButton *)sender {
    NSLog(@"Terms Button Pressed");
}


#pragma mark - OverlayView Methods
/*ensures that the view added streches properly to the screen*/
- (void) stretchToSuperView:(UIView*) view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSString *formatTemplate = @"%@:|[view]|";
    for (NSString * axis in @[@"H",@"V"]) {
        NSString * format = [NSString stringWithFormat:formatTemplate,axis];
        NSArray * constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:bindings];
        [view.superview addConstraints:constraints];
    }
}

-(void) createTimesUpOverlay   {
    TimesUpOverlayView *overlayView = [TimesUpOverlayView createOverlayView];
    self.view.bounds = overlayView.bounds;
    [self.view addSubview:overlayView];
    [self stretchToSuperView:self.view];
    self.overlayVC = overlayView;
}
@end
