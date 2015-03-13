//
//  HangmanSentence.h
//  HangmanGame
//
//  Created by Liu Di on 1/9/15.
//  Copyright (c) 2015 Liu Di. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HangmanSentence : NSObject
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
@property NSString *sentenceStatus;
@property NSMutableString *knowSentence;
-(NSString *)highestPercentage:(NSArray *)arr;
-(void) returnKey;
-(void) setUp;
-(void) endGamePrompt;
-(void) serverMode;
-(BOOL) ifAllKnown;
-(NSString *) currentStateServer;
-(id) initWithMode:(int)modeInput;

-(NSString *) serverInitialize:(NSString *) input;
-(NSString *) correctGuessServer;
-(NSString *) incorrectGuessServer:(NSString *)guess;
-(void) analysisServer:(NSString *)state withCode:(int) code;
-(void) patternFilteringServer;

@end
