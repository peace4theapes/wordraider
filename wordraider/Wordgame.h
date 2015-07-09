//
//  Wordgame.h
//  wordraider
//
//  Created by wordraider_backup N on 7/17/12.
//  Copyright (c) 2012 Peak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coin.h"
#import "Anagram.h"

@interface Wordgame : UIView
{
    NSMutableArray *coins;
    Coin *coinView;
}

@property (nonatomic, assign) NSString *word;
@property (nonatomic,retain) NSMutableArray *coins;
@property (nonatomic,assign) NSMutableArray *anagrams;
@property (nonatomic,assign) NSMutableArray *clearedAnagrams;

@property (nonatomic,assign) Coin *currCoin;
@property (nonatomic,assign) NSNumber *score;


-(void) startPuzzle;
-(void) checkWord: (NSString *)ana;
- (BOOL)isPresent:(NSString *)anag;
-(void) showAnimation: (NSString *)animateString;
-(void) updateScore;

@end
