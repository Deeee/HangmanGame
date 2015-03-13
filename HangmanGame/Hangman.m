//
//  Hangman.m
//  Hangman
//
//  Created by Liu Di on 9/28/14.
//  Copyright (c) 2014 Liu Di. All rights reserved.
//

#import "Hangman.h"
#import <UIKit/UIKit.h>
@implementation Hangman

//Properties to synthesize
@synthesize unknownPool;
@synthesize knownPoolArray;
@synthesize knownPoolString;
@synthesize filtered;
@synthesize chance;
@synthesize illegalCheck;
@synthesize receivedData;
@synthesize email;
@synthesize address;
@synthesize guessArray;
@synthesize globeDictionary;
@synthesize guessFilterArray;
@synthesize legalCharacterSet;
@synthesize globeCommonWords;
@synthesize commonFilterArray;
@synthesize wordLength;
@synthesize mode;
-(id) initWithMode:(int)modeInput {
    if(self) {
        self = [super init];
        self.mode = modeInput;
    }
    return self;
}


//Call this method when made a correct guess
-(NSString *)correctGuess:(NSString *)guess
{
    if (chance == 0 || ([[knownPoolString componentsSeparatedByString:@"?"] count] - 1) == 0) {
        [self endGamePrompt];
        return @"game is over";
    }
    NSInteger range = [unknownPool indexOfObject:guess];
    if (range != NSNotFound) {
        [unknownPool removeObjectAtIndex:range];
    }
    else {
        NSLog(@"error in correctGuess");
        return @"error in correctGuess";
    }
    for (NSString *letter in knownPoolArray) {
        if (![letter isEqualToString:@"?"]) {
            filtered = [filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS %@",letter]];
        }
    }
    
    NSString *result =[self highestPercentage:filtered];
    return result;
//    NSLog(@"my guess is %@, current state %@\nis it correct?(Y/N)",result, knownPoolString);
//    
//    //Input handler
//    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
//    NSData *inputData = [input availableData];
//    NSString *answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
//    if([answer isEqualToString:@"print\n"]) {
//        NSLog(@"prepare to print");
//        for (NSString *w in filtered) {
//            NSLog(@"%@",w);
//        }
//        input = [NSFileHandle fileHandleWithStandardInput];
//        inputData = [input availableData];
//        answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
//    }
//
//
//    if ([answer isEqualToString:@"Y\n"] || [answer isEqualToString:@"y\n"]) {
//        [self putIntoPosition:result];
//        [self patternFiltering];
//        [self correctGuess:result];
//    }
//
//    else {
//        [self incorrectGuess:result];
//    }
}

//Call this method when get a incorrect guess
-(NSString *) incorrectGuess:(NSString *)guess
{
    chance--;
    if (chance == 0 ||([[knownPoolString componentsSeparatedByString:@"?"] count] - 1) == 0) {
        [self endGamePrompt];
        return @"game is over";
    }
    filtered = [filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF CONTAINS %@)",guess]];
    
    NSInteger range = [unknownPool indexOfObject:guess];
    if (range != NSNotFound) {
        [unknownPool removeObjectAtIndex:range];
    }
    else {
        NSLog(@"error in correctGuess, guess is %@",guess);
    }
    for (NSString *letter in knownPoolArray) {
        if (![letter isEqualToString:@"?"]) {
            filtered = [filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF CONTAINS %@",letter]];
        }
    }
    NSString *result = [self highestPercentage:filtered];
    return result;
    
    
//    NSLog(@"my guess is %@, current state %@\nis it correct?(Y/N)",result, knownPoolString);
//    //Input handler
//    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
//    NSData *inputData = [input availableData];
//    NSString *answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
//    if([answer isEqualToString:@"print\n"]) {
//        NSLog(@"prepare to print");
//        for (NSString *w in filtered) {
//            NSLog(@"%@",w);
//        }
//        input = [NSFileHandle fileHandleWithStandardInput];
//        inputData = [input availableData];
//        answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
//    }
//
//    if ([answer isEqualToString:@"Y\n"] || [answer isEqualToString:@"y\n"]) {
//        [self putIntoPosition:result];
//        [self patternFiltering];
//        [self correctGuess:result];
//    }
//
//    else {
//        [self incorrectGuess:result];
//    }
}

//Calculate and find the highest percentage of each letter remaining in the unknowpool
-(NSString *)highestPercentage:(NSArray *)arr {
    NSLog(@"%ld, combine arr count %ld",[unknownPool count], [arr count]);
    NSInteger unknownPoolCount = [unknownPool count];
    NSInteger unknownPoolPercentage[unknownPoolCount], max = 0, resultIndex = 0;
    for (int i = 0; i < unknownPoolCount; i++) {
        unknownPoolPercentage[i] = 0;
    }
    NSInteger total = 0;
    for (NSString *word in arr) {
        total ++;
        for (int i = 0; i < unknownPoolCount; i++) {
            NSString *letter = [unknownPool objectAtIndex:i];
            NSRange range = [word rangeOfString:letter];
            if (range.location != NSNotFound) {
                unknownPoolPercentage[i]++;
            }
        }
        
    }
    for (int i = 0; i < unknownPoolCount; i++) {
        if (unknownPoolPercentage[i] > max) {
            max = unknownPoolPercentage[i];
            resultIndex = i;
        }
    }
    NSLog(@"total words remaining: %ld, there are %ld words contain letter %@",total,(long)max, [unknownPool objectAtIndex:resultIndex]);
    return [unknownPool objectAtIndex:resultIndex];
}

//Filter using pattern
-(void) patternFiltering {
    NSLog(@"before filtering, %ld word remaining, clue length %ld",[filtered count],[knownPoolString length]);
    filtered = [filtered filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF LIKE %@",knownPoolString]];
    NSLog(@"in pattern filtering, filtering clue is %@, %ld word remaining",knownPoolString,[filtered count]);

}

//Put correct letter into the correct position
-(void) putIntoPosition:(NSArray *)list withWord:(NSString *)guess{
    //Input handler
    NSInteger index;
    for (UIButton *b in list) {
        index = b.tag;
        NSRange r = {index, 1};
        NSLog(@"%ld is replaced to %@",index, guess);
        [knownPoolString replaceCharactersInRange:r withString:guess];
    }
    
}

//Initial calling method for starting the game
-(NSString *) playWithSelf:(NSInteger)length and:(NSArray *)dict {
    NSLog(@"length is %ld",length);
    NSPredicate *lengthPredicate = [NSPredicate predicateWithFormat:@"length == %d", length];
    filtered = [dict filteredArrayUsingPredicate:lengthPredicate];
    NSString *guess = [self highestPercentage:filtered];
    NSLog(@"my guess is %@, current state %@",guess, knownPoolString);
    
    NSLog(@"is it correct?(Y/N)");
    return guess;
    //Input handler
//    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
//    NSData *inputData = [input availableData];
//    NSString *answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
//    if([answer isEqualToString:@"print\n"]) {
//        for (NSString *w in filtered) {
//            NSLog(@"%@",w);
//        }
//    }
//    if ([answer isEqualToString:@"Y\n"] || [answer isEqualToString:@"y\n"]) {
//        [self putIntoPosition:guess];
//        [self patternFiltering];
//        [self correctGuess:guess];
//    }
//
//    else {
//        [self incorrectGuess:guess];
//    }
}

//Analysis the data recevied from server
-(void) analysis:(NSString *)str {
    for (int i = 0; i < [str length] - 1; i++) {
        const unichar c = [str characterAtIndex:i];
        if (c != '_') {
            NSString *s = [NSString stringWithCharacters:&c length:1];
            NSInteger range = [unknownPool indexOfObject:s];
            if (range != NSNotFound) {
                [unknownPool removeObjectAtIndex:range];
            }
            range = [knownPoolArray indexOfObject:s];
            [knownPoolString appendString:s];
            if (range == NSNotFound) {
                [knownPoolArray addObject:s];
            }
        }
        else {
            [knownPoolArray addObject:@"?"];
            [knownPoolString appendString:@"?"];
        }
    }
}

//Replace all pouncuations into spaces
-(NSString *) replaceWithSpace:(NSString *) str{
    NSMutableString *s = [[NSMutableString alloc] init];
    for (int i = 0; i < [str length]; i++) {
        const unichar c = [str characterAtIndex:i];
        if (c == '_') {
            [s appendString:@"_"];
        }
        else if(c == '-' || c == '\'' || c == '_') {
            [s appendString:@" "];
        }
        else {
            [s appendString:[NSString stringWithFormat:@"%c",c]];
        }
    }
    return [NSString stringWithString:s];

}

//Analysis the feed back from server
-(void) analysisServer:(NSString *)state withCode:(int) code{
    state = [self replaceWithSpace:state];
    
    state = [state lowercaseString];
    NSArray *words = [state componentsSeparatedByString:@" "];
    if (code == 1) {
        for (NSString *str in words) {
            NSMutableString *s = [NSMutableString  stringWithString:@""];
            for (int i = 0; i < [str length]; i++) {
                const unichar c = [str characterAtIndex:i];
                if (c != '_') {
                    [s appendString:@" "];
                }
                else{
                    [s appendString:@"?"];
                }
            }
            [guessArray addObject:s];
        }
        return;
    }
    int count = 0;
    for (NSString *str in words) {
        for (int i = 0; i < [str length]; i++) {
            const unichar c = [str characterAtIndex:i];
            if (c != '_') {
                NSString *s = [NSString stringWithCharacters:&c length:1];
                NSInteger range = [unknownPool indexOfObject:s];
                if (range != NSNotFound) {
                    [unknownPool removeObjectAtIndex:range];
                }
                [[guessArray objectAtIndex:count] replaceCharactersInRange:NSMakeRange(i, 1) withString:s];
            }

        }
        count++;
    }

}

//If all letters are guessed out
-(BOOL) ifAllKnown {
    for (NSString *word in guessArray) {
        if (([[word componentsSeparatedByString:@"?"] count] - 1) == 0) {
            
        }
        else{
            return false;
        }
    }
    return true;
}

-(BOOL) ifSingleWordKnown {
    if (([[knownPoolString componentsSeparatedByString:@"?"] count] - 1) == 0) {
        return true;
       
    }
    else{
        return false;
    }
}

//Combine known information into a string
-(NSString *) currentStateServer{
    NSString *finish = [guessArray componentsJoinedByString:@" "];
    return finish;
}

//Incorrect guess call fro server mode
-(void) incorrectGuessServer:(NSString *)guess response:(NSDictionary *) response{
    NSString *status = response[@"status"];
    NSString *token = response[@"token"];
    NSString *remaining_guesses = response[@"remaining_guesses"];
    NSMutableArray *combinefilter = [[NSMutableArray alloc] init];
    if ([status isEqualToString:@"DEAD"]) {
        NSString *learnString = [response[@"state"] lowercaseString];
        NSArray *learnArray = [learnString componentsSeparatedByString:@" "];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dictionary" ofType:@"txt"];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [fileHandle seekToEndOfFile];
        for (NSString *word in learnArray) {
            if (![globeDictionary containsObject:word]) {
                NSLog(@"LEARNING NEW WORD %@",word);
                [fileHandle writeData:[[NSString stringWithFormat:@"%@\n",word] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
        }
        
        return;
    }
    if ([self ifAllKnown]) {
        for (NSString *word in guessArray) {
            NSLog(@"%@",word);
        }
        return;
    }
    NSInteger range = [unknownPool indexOfObject:guess];
    if (range != NSNotFound) {
        [unknownPool removeObjectAtIndex:range];
    }
    else {
        NSLog(@"error in incorrectGuess, guess is %@",guess);
    }
    for (int i = 0; i < [guessArray count]; i++) {
        NSArray *arr = [guessFilterArray objectAtIndex:i];
        arr = [arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT (SELF CONTAINS %@)"]];
        [guessFilterArray replaceObjectAtIndex:i withObject:arr];
        [combinefilter addObjectsFromArray:arr];
    }
    NSString *ret = [self highestPercentage:combinefilter];
    NSLog(@"my guess is %@, current state %@\nsend it?(Y/N)",ret, [self currentStateServer]);

    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
    NSData *inputData = [input availableData];
    NSString *answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
    
    if ([answer isEqualToString:@"Y\n"] || [answer isEqualToString:@"y\n"]) {
        NSDictionary *curResponse = [self sendAnswer:token guess:ret];
        NSString *curRemaining_guesses = curResponse[@"remaining_guesses"];
        NSString *curState = curResponse[@"state"];
        
        if ([remaining_guesses isEqualToString:curRemaining_guesses]) {
            [self analysisServer:curState withCode:0];
            [self patternFilteringServer];
            [self correctGuessServer:ret response:curResponse];
        }
        else{
            [self incorrectGuessServer:ret response:curResponse];
        }
    }
    else {
        return;
    }

}

//Correct guess call for server mode
-(void) correctGuessServer:(NSString *)guess response:(NSDictionary *)response{
    NSString *status = response[@"status"];
    NSString *token = response[@"token"];
    NSString *remaining_guesses = response[@"remaining_guesses"];
    NSMutableArray *combinefilter = [[NSMutableArray alloc] init];
    if ([status isEqualToString:@"FREE"]) {
        NSString *learnString = [response[@"state"] lowercaseString];
        NSArray *learnArray = [learnString componentsSeparatedByString:@" "];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dictionary" ofType:@"txt"];
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [fileHandle seekToEndOfFile];
        for (NSString *word in learnArray) {
            if (![globeDictionary containsObject:word]) {
                NSLog(@"LEARNING WORD %@",word);
                [fileHandle writeData:[[NSString stringWithFormat:@"%@\n",word] dataUsingEncoding:NSUTF8StringEncoding]];
            }

        }
        return;
    }
    if ([self ifAllKnown]) {
        for (NSString *word in guessArray) {
            NSLog(@"%@",word);
        }
        return;
    }
    for (int i = 0; i < [guessArray count]; i++) {
        NSArray *arr = [guessFilterArray objectAtIndex:i];
        [combinefilter addObjectsFromArray:arr];
    }

    NSString *ret = [self highestPercentage:combinefilter];
    NSLog(@"my guess is %@, current state %@\nsend it?(Y/N)",ret, [self currentStateServer]);

    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
    NSData *inputData = [input availableData];
    NSString *answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
    
    if ([answer isEqualToString:@"Y\n"] || [answer isEqualToString:@"y\n"]) {
        NSDictionary *curResponse = [self sendAnswer:token guess:ret];
        NSString *curRemaining_guesses = curResponse[@"remaining_guesses"];
        NSString *curState = curResponse[@"state"];
        if ([remaining_guesses isEqualToString:curRemaining_guesses]) {
            [self analysisServer:curState withCode:0];
            [self patternFilteringServer];
            [self correctGuessServer:ret response:curResponse];
        }
        else{
            [self incorrectGuessServer:ret response:curResponse];
        }

    }

    else {
        return;
    }
}

//Pattern filter for server
-(void) patternFilteringServer {
    for (int i = 0; i < [guessArray count]; i++) {
        NSArray *arr = [guessFilterArray objectAtIndex:i];
        arr =[arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF LIKE %@",[guessArray objectAtIndex:i]]];
        [guessFilterArray replaceObjectAtIndex:i withObject:arr];
    }
}

//Initialize for server
-(void) serverInitialize:(NSDictionary *) response{
    NSString *state = response[@"state"];
    NSString *token = response[@"token"];
    NSString *remaining_guesses = response[@"remaining_guesses"];
    NSMutableArray *combineFilter = [[NSMutableArray alloc] init];
    guessFilterArray = [[NSMutableArray alloc] init];
    guessArray = [[NSMutableArray alloc] init];
    commonFilterArray = [[NSMutableArray alloc] init];
    
    [self analysisServer:state withCode:1];
    
    for (NSString *word in guessArray) {
        NSUInteger length = [word length];
        NSArray *filterArray = [[NSArray alloc] initWithArray:globeDictionary];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"length == %d", length];
        filterArray = [filterArray filteredArrayUsingPredicate:predicate];
        [combineFilter addObjectsFromArray:filterArray];
        [guessFilterArray addObject:filterArray];
    }
    NSString *ret = [self highestPercentage:combineFilter];
    NSLog(@"my guess is %@, current state %@\nsend it?(Y/N)",ret, [self currentStateServer]);

    NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
    NSData *inputData = [input availableData];
    NSString *answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
    
    if ([answer isEqualToString:@"Y\n"] || [answer isEqualToString:@"y\n"]) {
        NSDictionary *curResponse = [self sendAnswer:token guess:ret];
        NSString *curRemaining_guesses = curResponse[@"remaining_guesses"];
        NSString *curState = curResponse[@"state"];
        if ([remaining_guesses isEqualToString:curRemaining_guesses]) {
            [self analysisServer:curState withCode:0];
            [self patternFilteringServer];
            [self correctGuessServer:ret response:curResponse];
        }
        else{
            [self incorrectGuessServer:ret response:curResponse];
        }
    }
    else {
        return;
    }

    
}

//Communicate with server
-(NSDictionary*) sendAnswer:(NSString *)token guess:(NSString *)guess{
    NSMutableString *send = [[NSMutableString alloc] initWithString:address];
    [send appendString:[NSString stringWithFormat:@"%@&token=%@&guess=%@",email,token,guess]];
    NSURL *url = [NSURL URLWithString:send];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        NSLog(@"system error");
        return nil;
    }
    else{
        NSLog(@"server respond %@",json);
        return json;
    }
}



//Enter the server mode
-(void) serverMode{
    NSLog(@"In server Mode!");
    NSString *urlString = @"http://gallows.hulu.com/play?code=charles.L1993@gmail.com";
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    email = @"charles.L1993@gmail.com";
    address = @"http://gallows.hulu.com/play?code=";
    
    if (error)
    {
        NSLog(@"system error");
    }
    else
    {
        NSString *retVal = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"%@",retVal);
        [self serverInitialize:json];
        
    }

}

//Shell method below

//Setup for known and unknown pools, reset chance and guessed number
-(void) setUp{
    unknownPool = [NSMutableArray arrayWithObjects:@"a",@"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o" ,@"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    knownPoolArray = [[NSMutableArray alloc] init];
    knownPoolString = [[NSMutableString alloc] init];
    chance = 10;
}

-(NSString *) setUpWithInputAndRun:(NSInteger)length{
    wordLength = length;
    unknownPool = [NSMutableArray arrayWithObjects:@"a",@"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o" ,@"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", nil];
    knownPoolArray = [[NSMutableArray alloc] init];
    knownPoolString = [[NSMutableString alloc] init];
    chance = 10;
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    NSLog(@"Path is \"%@\", check this folder and make sure you have dictionary.txt inside, if not, copy it into the folder",bundlePath);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dictionary" ofType:@"txt"];
    NSString *file = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"path found is %@",path);

    path = [[NSBundle mainBundle] pathForResource:@"common" ofType:@"txt"];
    NSString *common = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    
    globeDictionary = [file componentsSeparatedByString:@"\n"];
    globeCommonWords = [common componentsSeparatedByString:@"\n"];
    illegalCheck = [NSCharacterSet characterSetWithCharactersInString:@"1234567890\n"];
    illegalCheck = [illegalCheck invertedSet];
    
    for (int i = 0; i < wordLength; i ++) {
        [knownPoolString appendString:@"?"];
        [knownPoolArray addObject:@"?"];
    }
    
    NSLog(@"knownpoolstring(length: %ld, word: %@)",[knownPoolString length],knownPoolString);
    return [self playWithSelf:wordLength and:globeDictionary];

}

//Press return key in shell
-(void) returnKey {
    NSLog(@"Hello, Welcome to hangman!");
}

//Print out a list of commands for the shell
-(void) commandList {
    NSLog(@"-q or -Q quit");
    NSLog(@"-h or -help command list");
    NSLog(@"-1 mode one, play with self");
    NSLog(@"-2 mode two, play with server");
}

//Print out prompt when game ends
-(void) endGamePrompt{
    if (([[knownPoolString componentsSeparatedByString:@"?"] count] - 1) == 0) {
        NSLog(@"Gotcha! the word is %@", knownPoolString);
    }
    else {
        NSLog(@"Sorry that I couldn't guess the word, May I know the word? :)");
        NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
        NSData *inputData = [input availableData];
        NSString *answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
        NSLog(@"Ha, %@, that was the word,I wish I couldn't have been smarter :)", answer);
    }
}

//Check player's input in the shell
//-(int) checkValue:(NSString *)str and:(NSArray *)dict {
//    if ([str isEqualToString:@"q\n"]||[str isEqualToString:@"Q\n"]) {
//        return -1;
//    }
//    else if ([str isEqualToString:@"\n"]) {
//        [self returnKey];
//        return 1;
//    }
//    else if ([str isEqualToString:@"h\n"]||[str isEqualToString:@"help\n"]) {
//        [self commandList];
//        return 1;
//    }
//    else {
//        if ([str isEqualToString:@"1\n"]) {
//            NSLog(@"enter mode one, play with self");
//            NSLog(@"type a text, use '_' to represent length. For example, for word 'apple', type _____, five underscores");
//            NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
//            NSData *inputData = [input availableData];
//            NSString *answer = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
//            
//            //Setup
//            for (int i = 0; i < [answer length] - 1; i ++) {
//                [knownPoolString appendString:@"?"];
//                [knownPoolArray addObject:@"?"];
//            }
//            
//            [self playWithSelf:answer and:dict];
//        }
//        else if([str isEqualToString:@"2\n"]){
//            NSLog(@"enter server mode, preparing sending package to server");
//            [self serverMode];
//            return 1;
//            
//            
//        }
//        else {
//            NSLog(@"can't find command for the option, type -help or -h for a list of command");
//            return 1;
//        }
//    }
//    return 1;
//    
//}
//
//
////Run the shell
//-(void) run{
//    [self setUp];
//    //Set path for dictionary, an external txt file that contains 49900 words
//    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
//    NSLog(@"Path is \"%@\", check this folder and make sure you have dictionary.txt inside, if not, copy it into the folder",bundlePath);
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"dictionary" ofType:@"txt"];
//    NSString *file = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    path = [[NSBundle mainBundle] pathForResource:@"common" ofType:@"txt"];
//    NSString *common = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    globeDictionary = [file componentsSeparatedByString:@"\n"];
//    globeCommonWords = [common componentsSeparatedByString:@"\n"];
//    illegalCheck = [NSCharacterSet characterSetWithCharactersInString:@"1234567890\n"];
//    illegalCheck = [illegalCheck invertedSet];
//    
//    NSFileHandle *input;
//    NSData *inputData;
//    NSString *str;
//    NSInteger flag = 1;
//    while(flag == 1)
//    {
//        [self commandList];
//        [self setUp];
//        input = [NSFileHandle fileHandleWithStandardInput];
//        inputData = [input availableData];
//        str = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
//        flag = [self checkValue:str and:globeDictionary];
//    }
//    
//}

@end