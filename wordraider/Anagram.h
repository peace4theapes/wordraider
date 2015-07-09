//
//  Anagram.h
//  wordraider
//
//  Created by wordraider_backup N on 7/20/12.
//  Copyright (c) 2012 Peak. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Anagram : NSObject
{
    NSString *anagrm;
    NSNumber *points;
}
@property (nonatomic, retain) NSString *anagrm;
@property (nonatomic, retain) NSNumber *points;

@end
