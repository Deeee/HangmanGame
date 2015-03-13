//
//  Header.h
//  Hangman
//
//  Created by Liu Di on 9/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface Hangman : NSObject
@property NSMutableArray *unknownPool;
@property NSMutableArray *knownPoolArray;
@property NSMutableString *knownPoolString;
@property NSArray *filtered;
@property NSInteger chance;
@property NSCharacterSet *illegalCheck;
@property NSData *receivedData;
@property NSString *email;
@property NSString *address;
@property NSMutableArray *guessArray;
@property NSArray *globeDictionary;
@property NSMutableArray *guessFilterArray;
@property NSMutableCharacterSet *legalCharacterSet;
@property NSArray *globeCommonWords;
@property NSMutableArray *commonFilterArray;
@property NSInteger wordLength;
@property int mode;
-(NSString *)highestPercentage:(NSArray *)arr;
-(NSString *) correctGuess:(NSString *)guess;
-(NSString *) incorrectGuess:(NSString *)guess;
-(NSString *) playWithSelf:(NSInteger)length and:(NSArray *)dict;
-(NSString *) setUpWithInputAndRun:(NSInteger)wordLength;
-(void) putIntoPosition:(NSArray *)list withWord:(NSString *)guess;
-(void) patternFiltering;
-(void) analysis:(NSString *)str;
-(void) returnKey;
-(void) setUp;
-(void) endGamePrompt;
-(void) serverMode;
-(BOOL) ifAllKnown;
-(BOOL) ifSingleWordKnown;
-(NSString *) currentStateServer;
-(id) initWithMode:(int)modeInput;
@end

