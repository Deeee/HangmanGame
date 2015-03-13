//
//  GameViewController.h
//  HangmanGame
//
//  Created by Liu Di on 11/21/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
@property int mode;
@property (weak, nonatomic) IBOutlet UITextField *UsrType;
@property (weak, nonatomic) IBOutlet UILabel *aiDisplay;
@property (nonatomic, strong) IBOutlet UITextField *typeWindow;
@property (nonatomic, strong) IBOutlet UILabel *display;

- (IBAction)backgroundTap:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;

@end
