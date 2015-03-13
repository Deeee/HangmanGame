//
//  BViewController.m
//  HangmanGame
//
//  Created by Liu Di on 12/30/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()

@end

@implementation BViewController {
    NSMutableString *typeWindowText;
    NSString *lastGuess;
    BOOL isGameStarted;
    BOOL isMenuShow;
    BOOL isMenuInitialized;
}
@synthesize display;
@synthesize sCorrect;
@synthesize sIncorrect;
@synthesize status;
@synthesize selectionWindow2;

@synthesize typeWindow;

@synthesize singleQuote;
@synthesize letter;
@synthesize space;
@synthesize enter;
@synthesize comma;
@synthesize deleteb;

@synthesize buttons;
@synthesize selections;
@synthesize clickedButtons;
@synthesize game;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    buttons = [[NSMutableArray alloc] init];

    [UIView transitionWithView:typeWindow
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.typeWindow.hidden = NO;
    [UIView transitionWithView:deleteb
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.deleteb.hidden = NO;
    [UIView transitionWithView:singleQuote
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.singleQuote.hidden = NO;
    [UIView transitionWithView:letter
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.letter.hidden = NO;
    [UIView transitionWithView:space
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.space.hidden = NO;
    [UIView transitionWithView:enter
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.enter.hidden = NO;
    [UIView transitionWithView:comma
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.comma.hidden = NO;
    
    display.text = @"hi im here! Please input word length indicating by _";
    display.adjustsFontSizeToFitWidth = NO;
    display.numberOfLines = 0;
    
    typeWindowText = [[NSMutableString alloc] initWithString:@""];
    typeWindow.text = typeWindowText;
    
    selectionWindow2.hidden = YES;
    status.text = @"";
    
    game = [[HangmanSentence alloc] init];
    isGameStarted = NO;
    isMenuShow = NO;
    isMenuInitialized = NO;
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

- (IBAction)clickOnIncorrect:(id)sender {
    if (isGameStarted == true) {
        lastGuess = [game incorrectGuessServer:lastGuess];
        display.text = [NSString stringWithFormat:@"my guess is %@", lastGuess];
        [self makeLabelFit:display];
    }
}

- (IBAction)clickOnCorrect:(id)sender {
    if (isGameStarted == true) {
        if (isMenuShow == false) {
            isMenuShow = true;
            [UIView transitionWithView:selectionWindow2
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:NULL
                            completion:NULL];
            self.selectionWindow2.hidden = NO;
            if (isMenuInitialized == false) {
                [self showSelection];
            }
        } else {
            isMenuShow = false;
            [UIView transitionWithView:selectionWindow2
                              duration:0.4
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:NULL
                            completion:NULL];
            self.selectionWindow2.hidden = YES;
        }
        
        
    }
}

- (void) showSelection {
    clickedButtons = [[NSMutableArray alloc] init];
    NSUInteger wordLength = [[game knowSentence] length];
    selectionWindow2.contentSize = CGSizeMake(80 * wordLength, selectionWindow2.frame.size.height);
    //    self.containerView.frame = CGRectMake(0, 0, selectionMenu.contentSize.width, selectionMenu.contentSize.height);
    
    //    [containerView ]
    //    [selectionMenu addSubview:containerView];
    [selectionWindow2 setUserInteractionEnabled:YES];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(reset:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"clear.png"] ] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,-20, 85, 85);
    [self.selectionWindow2 addSubview:button];
    //    [containerView setUserInteractionEnabled:YES];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 addTarget:self
                action:@selector(confirm:)
      forControlEvents:UIControlEventTouchUpInside];
    [button2 setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"confirm.png"] ] forState:UIControlStateNormal];
    button2.frame = CGRectMake(80, -20, 85, 85);
    
    [self.selectionWindow2 addSubview:button2];
    //    [containerView setUserInteractionEnabled:YES];
    
    
    int radius = 80;
    int buttonCount = 0;
    NSLog(@"here wordlength %lu, %@", wordLength,[game knowSentence]);
    
    for (int i = 0; i < wordLength; i++) {
        char curChar = [[game knowSentence] characterAtIndex:i];
        NSLog(@"knowsentence is %@, cur char is %c",[game knowSentence],curChar);
        if (curChar == ' ') {
            //1 for space
            curChar = '1';
        }
        else if (curChar == '\'') {
            NSLog(@"have a quote character");
            //2 for quote
            curChar = '2';
        }
        else if (curChar == ',') {
            //3 for comma
            curChar = '3';
        }
        //        NSLog(@"button :%c", [[game knownPoolString] characterAtIndex:i]);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.titleLabel.text = [NSString stringWithFormat:@"%c",curChar];
        NSLog(@"current titlelabel text is %@, cur char %c.",button.titleLabel.text, curChar);
        button.frame = CGRectMake(radius * buttonCount, 50, radius/2, radius/2);
        
        [button addTarget:self
                   action:@selector(tapOnButton:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%c.png",curChar] ] forState:UIControlStateNormal];
        if (curChar == '?') {
            [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ctouch.png",curChar] ] forState:UIControlStateSelected];
        }
        [self.selectionWindow2 addSubview:button];
        [buttons addObject:button];
        NSLog(@"adding object to buttons, count %ld",[buttons count]);
        buttonCount++;
    }
    isMenuInitialized = YES;

}

- (IBAction)tapOnQuote:(id)sender {
    [typeWindowText appendString:@"'"];
    typeWindow.text = typeWindowText;
    [self makeLabelFit:typeWindow];
}

- (IBAction)tapOnLetter:(id)sender {
    [typeWindowText appendString:@"_"];
    typeWindow.text = typeWindowText;
    [self makeLabelFit:typeWindow];


}

- (IBAction)tapOnSpace:(id)sender {
    [typeWindowText appendString:@" "];
    typeWindow.text = typeWindowText;
    [self makeLabelFit:typeWindow];


}

- (IBAction)tapOnComma:(id)sender {
    [typeWindowText appendString:@","];
    typeWindow.text = typeWindowText;
    [self makeLabelFit:typeWindow];


}

- (IBAction)tapOnEnter:(id)sender {
    lastGuess = [game serverInitialize:typeWindowText];
    NSString *prompt = [NSString stringWithFormat:@"my guess is %@",lastGuess];
    display.text = prompt;
    [UIView transitionWithView:typeWindow
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.typeWindow.hidden = YES;
    [UIView transitionWithView:deleteb
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.deleteb.hidden = YES;
    [UIView transitionWithView:singleQuote
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.singleQuote.hidden = YES;
    [UIView transitionWithView:letter
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.letter.hidden = YES;
    [UIView transitionWithView:space
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.space.hidden = YES;
    [UIView transitionWithView:enter
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.enter.hidden = YES;
    [UIView transitionWithView:comma
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    self.comma.hidden = YES;
    isGameStarted = true;
    status.text = [game sentenceStatus];
}

- (IBAction)tapOnDelete:(id)sender {
    
    NSRange range= NSMakeRange([typeWindowText length] - 1, 1);
    [typeWindowText replaceCharactersInRange:range withString:@""];
    typeWindow.text = typeWindowText;
    [self makeLabelFit:typeWindow];

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
- (void) putIntoPosition {
    NSLog(@"in put into position");
    NSMutableString *tempStatus = [[NSMutableString alloc] initWithString:@""];
    for (UIButton *b in buttons) {
        if (b.selected == YES) {
            [tempStatus appendString:lastGuess];
        }
        else {
            [tempStatus appendString:b.titleLabel.text];
        }
    }
    status.text = tempStatus;
    NSLog(@"tempstring print %@ ",tempStatus);
    [game analysisServer:tempStatus withCode:0];
}
- (IBAction) confirm:(UIButton *)gesture{
    NSLog(@"in confirmed, there are %ld buttons in clicked buttons, %ld buttons in buttons",[clickedButtons count],[buttons count]);
    if ([clickedButtons count] != 0) {
        [self putIntoPosition];
        status.text = [game sentenceStatus];
        for (UIButton *b in clickedButtons) {
            UIButton *button = (UIButton *)b;
            button.selected = !button.selected;
        }
        isMenuShow = false;
        [clickedButtons removeAllObjects];
        [game patternFilteringServer];
        lastGuess = [game correctGuessServer];
        display.text = [NSString stringWithFormat:@"my guess is %@", lastGuess];
        [self makeLabelFit:display];
        
        [UIView transitionWithView:selectionWindow2
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:NULL
                        completion:NULL];
        self.selectionWindow2.hidden = YES;
        isMenuInitialized = NO;
        for (UIButton *b in buttons) {
            [b removeFromSuperview];
        }
        [selectionWindow2 setNeedsDisplay];
        
        if ([game ifAllKnown]) {
            display.text = @"HAHA gotcha, the word is %@, game is about to restart in 5s",[game knownPoolString];
            [self.view setNeedsDisplay];
            sleep(5);
            [self restartGame];
        }
    }
    
}
-(void) restartGame{
    [self viewDidLoad];
}
-(IBAction)restart:(id)sender {
    [self viewDidLoad];
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
