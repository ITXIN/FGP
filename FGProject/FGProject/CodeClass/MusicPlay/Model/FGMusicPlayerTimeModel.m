//
//  FGMusicPlayerTimeModel.m
//  FGProject
//
//  Created by avazuholding on 2017/11/8.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGMusicPlayerTimeModel.h"

@implementation FGMusicPlayerTimeModel

-(instancetype)init{
    self = [super init];
    if (self){
        self.currMinStr = [NSString new];
        self.currSecStr = [NSString new];
        self.allMinuteStr = [NSString new];
        self.allSecondStr = [NSString new];
        self.processValue = 0.00;
        self.currentTime = @"00:00";
        self.durationTime = @"00:00";
    }
    return self;
}

@end
