//
//  HasDoneOperation.m
//  FGProject
//
//  Created by Bert on 16/1/18.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "HasDoneOperation.h"

@implementation HasDoneOperation
+ (void)setStarNumberWithDiffcultyLevelMark:(NSString *)leveMark
{
    NSInteger _startNum = [[NSUserDefaults standardUserDefaults]integerForKey:leveMark];
    _startNum ++;
    [[NSUserDefaults standardUserDefaults] setInteger:_startNum forKey:leveMark];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSInteger)starNumberWithDiffcultyLevelMark:(NSString *)leveMark
{
    return [[NSUserDefaults standardUserDefaults]integerForKey:leveMark];
}

+ (void)clearHadDoneDataWithDifcultyLevelMark:(NSString *)leveMark
{
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:leveMark];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
