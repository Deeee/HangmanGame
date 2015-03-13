//
//  MainViewController.m
//  HangmanGame
//
//  Created by Liu Di on 11/21/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "MainViewController.h"
#import "Hangman.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize game;
- (void)viewDidLoad {
    [super viewDidLoad];
//    GameViewController *gameView = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"gameView"];
//    self.game = gameView;
    
    // 1) Create the three views used in the swipe container view

    AViewController *AVc = [[AViewController alloc] initWithNibName:@"AViewController" bundle:nil];
    BViewController *BVc = [[BViewController alloc] initWithNibName:@"BViewController" bundle:nil];
    CViewController *CVc = [[CViewController alloc] initWithNibName:@"CViewController" bundle:nil];

    
    // 2) Add in each view to the container view hierarchy
    //    Add them in opposite order since the view hieracrhy is a stack
    [self addChildViewController:CVc];
    [self.scrollView addSubview:CVc.view];
    [CVc didMoveToParentViewController:self];
    
    [self addChildViewController:BVc];
    [self.scrollView addSubview:BVc.view];
    [BVc didMoveToParentViewController:self];
    
    [self addChildViewController:AVc];
    [self.scrollView addSubview:AVc.view];
    [AVc didMoveToParentViewController:self];
    
    // 3) Set up the frames of the view controllers to align
    //    with eachother inside the container view
    CGRect adminFrame = AVc.view.frame;
    adminFrame.origin.x = CGRectGetWidth(adminFrame);
    BVc.view.frame = adminFrame;
    
    CGRect BFrame = BVc.view.frame;
    BFrame.origin.x = 2*CGRectGetWidth(BFrame);
    CVc.view.frame = BFrame;
    
    
    // 4) Finally set the size of the scroll view that contains the frames
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
    CGFloat scrollWidth = 3 * CGRectGetWidth(self.view.frame);
    CGFloat scrollHeight = self.view.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(scrollWidth, scrollHeight);

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
