//
//  BViewController.h
//  HangmanGame
//
//  Created by Liu Di on 12/30/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HangmanSentence.h"
@interface BViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UIButton *sCorrect;
@property (weak, nonatomic) IBOutlet UIButton *sIncorrect;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *typeWindow;
@property (weak, nonatomic) IBOutlet UIScrollView *selectionWindow2;

@property (weak, nonatomic) IBOutlet UIButton *singleQuote;
@property (weak, nonatomic) IBOutlet UIButton *letter;
@property (weak, nonatomic) IBOutlet UIButton *space;
@property (weak, nonatomic) IBOutlet UIButton *enter;
@property (weak, nonatomic) IBOutlet UIButton *comma;
@property (weak, nonatomic) IBOutlet UIButton *deleteb;

@property HangmanSentence *game;
@property NSMutableArray* selections;
@property NSMutableArray* buttons;
@property NSMutableArray* clickedButtons;

- (IBAction)tapOnQuote:(id)sender;
- (IBAction)tapOnLetter:(id)sender;
- (IBAction)tapOnSpace:(id)sender;
- (IBAction)tapOnComma:(id)sender;
- (IBAction)tapOnEnter:(id)sender;
    - (IBAction)tapOnDelete:(id)sender;
@end
