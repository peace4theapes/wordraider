//
//  Wordgame.m
//  wordraider
//
//  Created by wordraider_backup N on 7/17/12.
//  Copyright (c) 2012 Peak. All rights reserved.
//

#import "Wordgame.h"

@implementation Wordgame
@synthesize word, coins, anagrams, currCoin, clearedAnagrams, score;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor blackColor];
        self.currCoin = nil;       
        self.word = [[NSString alloc] init];
        self.anagrams = [[NSMutableArray alloc] init];
        self.score = [[NSNumber alloc] init];
        self.clearedAnagrams = [[NSMutableArray alloc] init];
        //self.word = @"whatever";
        self.coins = [[NSMutableArray alloc] init];
        
        [self startPuzzle];
        
    }
    //NSLog(@"HEHEHE - %@",self.score);
    return self;
}

-(void) checkWord: (NSString *)ana
{
    for(int i=0; i<self.anagrams.count; i++)
    {
        Anagram *tempAnagram = [self.anagrams objectAtIndex:i];
        if([tempAnagram.anagrm isEqualToString:ana])
        {
            //self.score = [NSNumber numberWithInt:[self.score intValue] + [tempAnagram.points intValue]];
            [self showAnimation:ana];
            [self.clearedAnagrams addObject:tempAnagram];
            [self.anagrams removeObject:tempAnagram];
            [self updateScore];
        }
    }
}


-(void) updateScore
{
    NSNumber *tempScore = [NSNumber numberWithInt:0];
    for(Anagram *ang in self.clearedAnagrams)
    {
        tempScore = [NSNumber numberWithInt:[tempScore  intValue] + [ang.points intValue]];
    }
    self.score = tempScore;
    
}

- (BOOL)isPresent:(NSString *)anag
{
    //BOOL *presento = NO;
    for(int i=0; i<self.anagrams.count; i++)
    {
        Anagram *tempAnagram = [self.anagrams objectAtIndex:i];
        if([tempAnagram.anagrm isEqualToString:anag])
        {
            return YES;
        }
    }
    
    return NO;
}

-(void) startPuzzle
{    
	
    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGRect rect = [[UIApplication sharedApplication] statusBarFrame];
//    CGFloat screenWidth = screenRect.size.width - rect.size.height;    
    
	[self.coins removeAllObjects];
		
    for( int y=0; y<self.word.length; y++ ){        
        
        
        CGRect frame = CGRectMake(0,0, 60, 60 );
        coinView = [[Coin alloc] initWithFrame:frame];
        [coinView setBackgroundColor:[UIColor clearColor]];
        [coinView setCharToShow:[NSString stringWithFormat:@"%c", [self.word characterAtIndex:y]]];               
        [coins addObject:coinView];		
        
        //[self addSubView:coinView];
        
        [self insertSubview:coinView atIndex:0];
     		
	}
    
    [self shuffle];
    
    CGPoint centerOfCircle = CGPointMake(screenRect.size.width/2, screenRect.size.height/2 - 60);
    //CGPoint centerOfCircle = CGPointMake(150, 150);
    float radius = 120.0;
    
    int count = 0;
    float angleStep = 2.0f * M_PI / [coins count];
    
    for (UIView *view in coins) {
        float xPos = cosf(angleStep * count) * radius;
        float yPos = sinf(angleStep * count) * radius;
        view.center = CGPointMake(centerOfCircle.x + xPos, centerOfCircle.y +yPos);
        count++;
    }

    //NSLog(@"%@",self.anagrams);
    
}



-(void) shuffle
{
    for (int i = [self.coins count]; i > 1; i--)
        [self.coins exchangeObjectAtIndex:i-1 withObjectAtIndex:random()%i];
}


-(void) showAnimation: (NSString *)animateString
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGPoint centerOfLabel = CGPointMake(screenRect.size.width/2, screenRect.size.height/2 - 60);
    
    //label.center = centerOfLabel;

    CGRect frame = CGRectMake(0,0, 150, 50 );
    UILabel *anaLabel = [ [UILabel alloc ] initWithFrame:frame];
    anaLabel.center = centerOfLabel;
    anaLabel.textAlignment =  UITextAlignmentCenter;
    anaLabel.textColor = [UIColor whiteColor];
    anaLabel.backgroundColor = [UIColor clearColor];
    anaLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(25.0)];
    anaLabel.text = animateString;
    [self addSubview:anaLabel];
    [anaLabel setAlpha:0.0];
    [anaLabel release];
    
    [UIView animateWithDuration:1.0 
                          delay:0 
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void) 
     {
         [anaLabel setAlpha:1.0];
     } 
                     completion:^(BOOL finished) 
     {
         if(finished)
         {
             [UIView animateWithDuration:1.5 
                                   delay:0.5
                                 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                              animations:^(void) 
              {
                  [anaLabel setAlpha:0.0];
              } 
                              completion:^(BOOL finished) 
              {
                  if(finished)
                      NSLog(@"Hurray. Label fadedIn & fadedOut");
              }];
         }
     }];
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */@end
