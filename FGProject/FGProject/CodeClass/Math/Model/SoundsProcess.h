//
//  SoundsProcess.h
//  FGProject
//
//  Created by Bert on 16/1/14.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundsProcess : NSObject
/**
 *  播放声音
 */
+ (void)playSoundWithNameStr:(NSString *)soundNameStr;
/**
 *  震动
 */
+ (void)vibratePlay;
@end
