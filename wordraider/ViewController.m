//
//  ViewController.m
//  wordraider
//
//  Created by wordraider_backup N on 7/17/12.
//  Copyright (c) 2012 Peak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
-(Coin *) coinAtPoint:(CGPoint) point;
@end

@implementation ViewController

@synthesize gameView,currAnagram,countLabel,scrollLabel,scoreLabel,database,totalRecords;

- (void)viewDidLoad
{
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docsPath = [paths objectAtIndex:0];
//    NSString *path = [docsPath stringByAppendingPathComponent:@"wordraider.db"];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wordraider" ofType:@"db"];
    
    NSLog(@"%@",path);
    FMDatabase *tmpdatabase = [FMDatabase databaseWithPath:path];
    self.database = tmpdatabase;
    self.database.logsErrors = YES;
    
    [self.database open];

    
    FMResultSet *results = [self.database executeQuery:@"select count(*) as totcount from wordraider"];
    
    while([results next]) {        
        NSInteger tmpCount  = [results intForColumn:@"totcount"];
        self.totalRecords = [NSNumber numberWithInt:tmpCount];
    }     
    
    [self.database close];
    
    Wordgame *newWord = [self getNewWord];
    self.gameView = newWord;
    
    self.currAnagram = @"";
    
    //gameView.anagrams = [angs mutableCopy];
    [self.gameView startPuzzle];
        
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:gameView];
    
    
    //anagram count label
    CGRect frame = CGRectMake(0,0, 80, 60 );
    UILabel *tempLabel = [ [UILabel alloc ] initWithFrame:frame];
    tempLabel.textAlignment =  UITextAlignmentCenter;
    tempLabel.textColor = [UIColor whiteColor];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(35.0)];
    tempLabel.text = [NSString stringWithFormat:@"%d", [self.gameView.anagrams count]];
    //NSLog(@"%@",self.gameView.anagrams);
    countLabel = tempLabel;
    [self.view addSubview:countLabel];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect scroll = CGRectMake(0,screenRect.size.height-105, screenRect.size.width, 40 );
    AutoScrollLabel *scLabel = [[AutoScrollLabel alloc] initWithFrame:scroll];
    scLabel.text = [self textForScroll];
    scrollLabel = scLabel;
    [self.view addSubview:scrollLabel];
    
    
    CGRect score = CGRectMake(screenRect.size.width-120,0, 70, 70 );
    UILabel *stempLabel = [ [UILabel alloc ] initWithFrame:score];
    stempLabel.textAlignment =  UITextAlignmentCenter;
    stempLabel.textColor = [UIColor whiteColor];
    stempLabel.backgroundColor = [UIColor clearColor];
    stempLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(35.0)];
    //NSLog(@"HIHI - %d",[self.gameView.score intValue]);
    stempLabel.text = [NSString stringWithFormat:@"%d", [self.gameView.score intValue]];
    
    scoreLabel = stempLabel;
    [self.view addSubview:scoreLabel];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    
}


-(IBAction)newGame:(id)sender
{
    [self startNewGame];
}

-(void) startNewGame
{
    [self.gameView removeFromSuperview];
    [self.gameView release];
    Wordgame *newWord = [self getNewWord];
    self.gameView = newWord;
    self.currAnagram = @"";
    [self checkAnagram];
    [self.gameView startPuzzle];
    [self.gameView setNeedsDisplay];
    [self.view addSubview:gameView];
}


-(Wordgame *) getNewWord
{
    Wordgame *newGame = [[Wordgame alloc] init];
        
    [self.database open];
    
      
    FMResultSet *newResults = [self.database executeQuery:@"SELECT * FROM wordraider ORDER BY RANDOM() LIMIT 1;"];
    
    while([newResults next]) {
        NSString *tmpWord = [newResults stringForColumn:@"word"];
        newGame.word = tmpWord;
        
        NSString *tmpangs = [newResults stringForColumn:@"anagrams"];
        NSArray *angs  = [tmpangs componentsSeparatedByString:@","];
        
        for(NSString *anaString in angs)
        {
            Anagram *tempAnagram = [[Anagram alloc] init];
            tempAnagram.anagrm = anaString;
            tempAnagram.points = [NSNumber numberWithInt:anaString.length];
            [newGame.anagrams addObject:tempAnagram];
        }
        
        NSLog(@"User: %@ - %@",tmpWord, tmpangs);
    }
    
    [self.database close];   
    
    newGame.score = [NSNumber numberWithInt:0];    
    
    return newGame;

    
}



-(void) appendNewChar:(NSString*)charToAppend
{
    self.currAnagram = [[[currAnagram autorelease] stringByAppendingString:charToAppend] retain];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    NSLog(@"Began start");
    CGPoint firstTouch = [touch locationInView:self.view];
    
    Coin *startCoin = [self coinAtPoint:firstTouch];
    
    if(startCoin != nil)
    {
        NSLog(@"Began found");
        self.gameView.currCoin = startCoin;
        [self appendNewChar:startCoin.charToShow];
    }
    else {
        self.gameView.currCoin = nil;
    }
}    



-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *myTouch = [touches anyObject];
        NSLog(@"Moved start");
    CGPoint point = [myTouch locationInView:self.view];
    
    Coin *movedCoin = [self coinAtPoint:point];
    
    if(movedCoin != nil)
    {       NSLog(@"Moved found");
        if(self.gameView.currCoin != movedCoin)
        {
            self.gameView.currCoin = movedCoin;
            [self appendNewChar:movedCoin.charToShow];
        }
    }
    else {
        self.gameView.currCoin = nil;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{       
    [self checkAnagram]; 
}


-(void) checkAnagram
{   //NSLog(@"HAHA - %d",[self.gameView.score intValue]);
    [self.gameView checkWord:self.currAnagram];
    [countLabel setText:[NSString stringWithFormat:@"%d", [self.gameView.anagrams count]]];
    [scoreLabel setText:[NSString stringWithFormat:@"%d", [self.gameView.score intValue]]];
    [scrollLabel setText:[self textForScroll]];
    //[scrollLabel setNeedsDisplay];
    self.currAnagram = @"";
}



-(Coin *) coinAtPoint:(CGPoint) point
{
	CGRect touchRect = CGRectMake(point.x, point.y, 1.0, 1.0);
	
	for( Coin *c in gameView.coins ){
		if( CGRectIntersectsRect(c.frame, touchRect) ){
			return c; 
		}		
	}
	return nil;
}

-(NSString *) textForScroll
{
    NSString *tempText = @"";
    //NSLog(@"%@",self.gameView.clearedAnagrams);
    
    for(int i=self.gameView.clearedAnagrams.count-1; i>=0;  i--)
    {
        Anagram *ag = [self.gameView.clearedAnagrams objectAtIndex:i];
        tempText = [tempText stringByAppendingString:[NSString stringWithFormat:@" %@",ag.anagrm]];
    }
   /*
    for(Anagram *a in self.gameView.clearedAnagrams)
    {
        //float fontSize = 35.0 + a.points.floatValue;
        tempText = [tempText stringByAppendingString:[NSString stringWithFormat:@" %@", a.anagrm]];
    }
    */
    //NSLog(@"%@", tempText);
    return tempText;
    
}
@end
