//
//  GameViewController.m
//  HangmanGame
//
//  Created by Liu Di on 11/21/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController
@synthesize mode;
@synthesize typeWindow;
@synthesize display;
@synthesize aiDisplay;
@synthesize UsrType;
- (void)viewDidLoad {
    [super viewDidLoad];
//    display = [[UILabel alloc] initWithFrame:CGRectMake(300, 300, 200, 200)];
    
    if (mode == 1) {
        aiDisplay.text = @"hi im here! Please input word length indicating by _";
        NSLog(@"been here");
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return true;
}

- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
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
