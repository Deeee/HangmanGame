//
//  AViewController.m
//  HangmanGame
//
//  Created by Liu Di on 12/30/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "AViewController.h"
@interface AViewController ()

@end

@implementation AViewController {
    NSString *lastGuess;
    BOOL isGameStarted;
    BOOL isMenuShow;
    BOOL isMenuInitialized;
    BOOL isConfirmClicked;
    NSArray *_pickerData;
    NSInteger selectedLength;
}

@synthesize aiDisplay;
@synthesize UsrType;
@synthesize lengthPicker;
@synthesize lengthConfirm;

@synthesize selectionMenu;
@synthesize game;
@synthesize buttons;
@synthesize clickedButtons;
@synthesize selections;
//@synthesize containerView;
@synthesize knownWord;

@synthesize correct;
@synthesize incorrect;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    buttons = [[NSMutableArray alloc] init];
    
    UsrType.delegate = self;
    self.lengthPicker.dataSource = self;
    self.lengthPicker.delegate = self;
    selectedLength = 1;
    
    [UIView transitionWithView:lengthPicker
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.lengthPicker.hidden = NO;
    [UIView transitionWithView:lengthConfirm
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.lengthConfirm.hidden = NO;
    [lengthPicker selectRow:0 inComponent:0 animated:YES];
    
    aiDisplay.text = @"hi im here! Please input word length indicating by _";
    aiDisplay.adjustsFontSizeToFitWidth = NO;
    aiDisplay.numberOfLines = 0;
    
    isGameStarted = false;
    isMenuShow = false;
    isMenuInitialized = false;
    isConfirmClicked = NO;
    
    selectedLength = 0;
    [selectionMenu setNeedsDisplay];
    
    _pickerData = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11",@"12",@"13",@"14"];
    selectionMenu.hidden = YES;
    knownWord.text = @"";
    [self makeLabelFit:aiDisplay];
//    CGFloat fontSize = 30;
//    while (fontSize > 0.0)
//    {
//        CGSize size = [aiDisplay.text sizeWithFont:[UIFont fontWithName:@"Verdana" size:fontSize] constrainedToSize:CGSizeMake(labelRect.size.width, 10000) lineBreakMode:UILineBreakModeWordWrap];
//        
//        if (size.height <= labelRect.size.height) break;
//        
//        fontSize -= 1.0;
//    }
//    
//    //set font size
//    aiDisplay.font = [UIFont fontWithName:@"Verdana" size:fontSize];
    // Do any additional setup after loading the view from its nib.
}

- (void)makeLabelFit:(UILabel *)label {
    CGRect labelRect = CGRectMake(10, 50, 300, 50);
    label.adjustsFontSizeToFitWidth = NO;
    label.numberOfLines = 0;
    
    CGFloat fontSize = 30;
    while (fontSize > 0.0)
    {
        CGSize size = [label.text sizeWithFont:[UIFont fontWithName:@"Verdana" size:fontSize] constrainedToSize:CGSizeMake(labelRect.size.width, 10000) lineBreakMode:UILineBreakModeWordWrap];
        
        if (size.height <= labelRect.size.height) break;
        
        fontSize -= 1.0;
    }
    
    //set font size
    label.font = [UIFont fontWithName:@"Verdana" size:fontSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
    // Dispose of any resources that can be recreated.
}
- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)clickOnIncorrect:(id)sender {
    if (isGameStarted == true) {
        lastGuess = [game incorrectGuess:lastGuess];
        aiDisplay.text = [NSString stringWithFormat:@"my guess is %@", lastGuess];
        [self makeLabelFit:aiDisplay];
    }
}

- (IBAction)clickOnCorrect:(id)sender {
    if (isGameStarted == true) {
        if (isMenuShow == false) {
            isMenuShow = true;
            [UIView transitionWithView:selectionMenu
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:NULL
                            completion:NULL];
            self.selectionMenu.hidden = NO;
            if (isMenuInitialized == false) {
                [self showSelection];
            }
        } else {
            isMenuShow = false;
            [UIView transitionWithView:selectionMenu
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:NULL
                            completion:NULL];
            self.selectionMenu.hidden = YES;
        }


    }
}


- (void) showSelection {
    
    clickedButtons = [[NSMutableArray alloc] init];
    NSUInteger wordLength = [game wordLength];
    selectionMenu.contentSize = CGSizeMake(80 * wordLength, selectionMenu.frame.size.height);
//    self.containerView.frame = CGRectMake(0, 0, selectionMenu.contentSize.width, selectionMenu.contentSize.height);

    //    [containerView ]
//    [selectionMenu addSubview:containerView];
    [selectionMenu setUserInteractionEnabled:YES];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(reset:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"clear.png"] ] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,-20, 85, 85);
    [self.selectionMenu addSubview:button];
//    [containerView setUserInteractionEnabled:YES];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 addTarget:self
                action:@selector(confirm:)
      forControlEvents:UIControlEventTouchUpInside];
    [button2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"confirm.png"] ] forState:UIControlStateNormal];
    button2.frame = CGRectMake(80, -20, 85, 85);
    
    [self.selectionMenu addSubview:button2];
//    [containerView setUserInteractionEnabled:YES];
    

    int radius = 80;
    int buttonCount = 0;
    NSLog(@"here wordlength %lu, %@", wordLength,[game knownPoolString]);

    for (int i = 0; i < wordLength; i++) {
        char curChar = [[game knownPoolString] characterAtIndex:i];
//        NSLog(@"button :%c", [[game knownPoolString] characterAtIndex:i]);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.text = [NSString stringWithFormat:@"%c",curChar];

        button.frame = CGRectMake(radius * buttonCount, 50, radius/2, radius/2);
        
        [button addTarget:self
                   action:@selector(tapOnButton:)
         forControlEvents:UIControlEventTouchUpInside];

        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%c.png",curChar] ] forState:UIControlStateNormal];
        if (curChar == '?') {
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ctouch.png",curChar] ] forState:UIControlStateSelected];
        }
        [self.selectionMenu addSubview:button];
        [buttons addObject:button];
        NSLog(@"adding object to buttons, count %ld",[buttons count]);
        buttonCount++;
    }
    isMenuInitialized = YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"text should return");
    if([textField.text containsString:@"print"]) {
        NSArray *filtered = [game filtered];
        NSLog(@"-----------------------");
        for (NSString *word in filtered) {
            NSLog(@"%@",word);
        }
        NSLog(@"-----------------------");

    }
    
    textField.text = @"";
    return true;
}

- (IBAction) tapOnButton:(UIButton *)gesture{
    NSUInteger count = [clickedButtons count];
    UIButton *button = (UIButton *)gesture;
    button.selected = !button.selected;
    NSLog(@"passs! %ld",count);
    
    if ([gesture isKindOfClass:[UIButton class]]) {
        if ([clickedButtons containsObject:button]) {
            [clickedButtons removeObject:button];
        }
        else {
            if ([gesture.titleLabel.text isEqualToString:@"?"]) {
                [clickedButtons addObject:gesture];
                count++;
            }
        }
    }

    
}
- (IBAction) reset:(UIButton *)gesture{
    for (UIButton *b in clickedButtons) {
        UIButton *button = (UIButton *)b;
        button.selected = !button.selected;
    }
    [clickedButtons removeAllObjects];
}

- (IBAction) confirm:(UIButton *)gesture{
    NSLog(@"in confirmed, there are %ld buttons in clicked buttons, %ld buttons in buttons",[clickedButtons count],[buttons count]);
    if ([clickedButtons count] != 0) {
        [game putIntoPosition:clickedButtons withWord:lastGuess];
        knownWord.text = [game knownPoolString];
        for (UIButton *b in clickedButtons) {
            UIButton *button = (UIButton *)b;
            button.selected = !button.selected;
        }
        isMenuShow = false;
        [clickedButtons removeAllObjects];
        [game patternFiltering];
        lastGuess = [game correctGuess:lastGuess];
        aiDisplay.text = [NSString stringWithFormat:@"my guess is %@", lastGuess];
        [self makeLabelFit:aiDisplay];
        
        [UIView transitionWithView:selectionMenu
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        self.selectionMenu.hidden = YES;
        isMenuInitialized = NO;
        for (UIButton *b in buttons) {
            [b removeFromSuperview];
        }
        [selectionMenu setNeedsDisplay];
        
        if ([game ifSingleWordKnown]) {
            aiDisplay.text = @"HAHA gotcha, the word is %@, game is about to restart in 5s",[game knownPoolString];
            [self.view setNeedsDisplay];
            sleep(5);
            [self restartGame];
        }
    }

}

-(IBAction)restart:(id)sender {
    [self viewDidLoad];
}

-(IBAction)confirmLength:(id)sender {
    if (selectedLength != 0) {
        NSLog(@"selected length is %lu",selectedLength);
        [UIView transitionWithView:lengthPicker
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        self.lengthPicker.hidden = YES;
        [UIView transitionWithView:lengthConfirm
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        self.lengthConfirm.hidden = YES;
        game = [[Hangman alloc] init];
        lastGuess = [game setUpWithInputAndRun:selectedLength];
        knownWord.text = [game knownPoolString];
        NSString *prompt = [NSString stringWithFormat:@"my guess is %@",lastGuess];
        aiDisplay.text = prompt;
        isGameStarted = YES;
    }
    else {
        aiDisplay.text = @"Cannot start game with a word that has 0 length";
    }

}


-(void) restartGame{
    [self viewDidLoad];
    selectedLength = 1;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

// Catpure the picker view selection
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // This method is triggered whenever the user makes a change to the picker selection.
    // The parameter named row and component represents what was selected.
    selectedLength = row + 1;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = _pickerData[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
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
