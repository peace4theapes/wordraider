//
//  Coin.m
//  wordraider
//
//  Created by wordraider_backup N on 7/17/12.
//  Copyright (c) 2012 Peak. All rights reserved.
//

#import "Coin.h"

@implementation Coin

@synthesize charToShow;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    
    
    
     CGContextRef ctx = UIGraphicsGetCurrentContext();
     CGContextAddEllipseInRect(ctx, rect);
     /* with blue color
     CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blueColor] CGColor]));
     */
     CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:173/255.0f green:198/255.0f blue:234/255.0f alpha:1] CGColor]));
     CGContextFillPath(ctx);
     
    
   // CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextAddEllipseInRect(ctx, 
                              CGRectMake(
                                         rect.origin.x + 5, 
                                         rect.origin.y + 5, 
                                         rect.size.width - 10, 
                                         rect.size.height - 10));
    /* with red color
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor redColor] CGColor]));
    */
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor colorWithRed:19/255.0f green:44/255.0f blue:81/255.0f alpha:1] CGColor]));
    CGContextEOFillPath(ctx);

    UILabel *characterLabel = [ [UILabel alloc ] initWithFrame:self.bounds];
    characterLabel.textAlignment =  UITextAlignmentCenter;
    characterLabel.textColor = [UIColor blackColor];
    characterLabel.backgroundColor = [UIColor clearColor];
    characterLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(22.0)];
    characterLabel.text = self.charToShow;
    [self addSubview:characterLabel];
    [characterLabel release];
    
}


@end
