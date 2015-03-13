//
//  MainViewController.h
//  HangmanGame
//
//  Created by Liu Di on 11/21/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
@interface MainViewController : UIViewController
@property GameViewController *game;
@property IBOutlet UIScrollView *scrollView;


@end
