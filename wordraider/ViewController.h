//
//  ViewController.h
//  wordraider
//
//  Created by wordraider_backup N on 7/17/12.
//  Copyright (c) 2012 Peak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wordgame.h"
#import "Coin.h"
#import "Anagram.h"
#import "AutoScrollLabel.h"
#import "FMDatabase.h"


@interface ViewController : UIViewController
{
    Wordgame *gameView;
    FMDatabase *database;
}

@property (nonatomic, retain) Wordgame *gameView;
@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, assign) NSNumber *totalRecords;
@property (nonatomic, assign) NSString *currAnagram;
@property (nonatomic, retain) IBOutlet UILabel *countLabel;
@property (nonatomic, retain) IBOutlet AutoScrollLabel *scrollLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;

-(IBAction)newGame:(id)sender;
-(void) startNewGame;
-(Wordgame *) getNewWord;
-(void) appendNewChar:(NSString *) charToAppend;
-(void) checkAnagram;
-(NSString *) textForScroll;
@end
