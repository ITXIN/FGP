//
//  SoundsProcess.h
//  FGProject
//
//  Created by Bert on 16/1/14.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundsProcess : NSObject
+ (SoundsProcess *)shareInstance;
@property (nonatomic,assign) BOOL isPlaySound;

- (void)playSoundOfTock;
//wonderful
- (void)playSoundOfWonderful;
//wrong
- (void)playSoundOfWrong;
//fireworks
- (void)playSoundOfFireworks;

/**
 *  播放声音
 */
//+ (void)playSoundWithNameStr:(NSString *)soundNameStr;
/**
 *  震动
 */
- (void)vibratePlay;

@end
