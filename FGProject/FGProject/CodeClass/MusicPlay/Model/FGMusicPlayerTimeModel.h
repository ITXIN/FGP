//
//  FGMusicPlayerTimeModel.h
//  FGProject
//
//  Created by avazuholding on 2017/11/8.
//  Copyright © 2017年 bert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGMusicPlayerTimeModel : NSObject
@property (nonatomic,strong) NSString *currMinStr;
@property (nonatomic,strong) NSString *currSecStr;
@property (nonatomic,strong) NSString *allMinuteStr;
@property (nonatomic,strong) NSString *allSecondStr;
@property (nonatomic,assign) CGFloat processValue;

@property (nonatomic,strong) NSString *currentTime;
@property (nonatomic,strong) NSString *durationTime;



@end
