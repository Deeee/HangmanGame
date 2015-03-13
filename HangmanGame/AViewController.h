//
//  AViewController.h
//  HangmanGame
//
//  Created by Liu Di on 12/30/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hangman.h"

@interface AViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *knownWord;
@property (weak, nonatomic) IBOutlet UIScrollView *selectionMenu;
@property (strong, nonatomic) IBOutlet UITextField *UsrType;
@property (weak, nonatomic) IBOutlet UILabel *aiDisplay;
@property (weak, nonatomic) IBOutlet UIButton *correct;
@property (weak, nonatomic) IBOutlet UIButton *incorrect;
@property (weak, nonatomic) IBOutlet UIPickerView *lengthPicker;
@property (weak, nonatomic) IBOutlet UIButton *lengthConfirm;
//@property (weak, nonatomic) IBOutlet UIView *containerView;
@property Hangman *game;
@property NSMutableArray* selections;
@property NSMutableArray* buttons;
@property NSMutableArray* clickedButtons;


- (IBAction)backgroundTap:(id)sender;
- (IBAction)restart:(id)sender;
-(IBAction)confirmLength:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
