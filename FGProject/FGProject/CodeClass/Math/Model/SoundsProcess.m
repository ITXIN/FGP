//
//  SoundsProcess.m
//  FGProject
//
//  Created by Bert on 16/1/14.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "SoundsProcess.h"
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
@implementation SoundsProcess

+ (void)playSoundWithNameStr:(NSString *)soundNameStr
{
    NSArray *typeArr = @[@"wav",@"mp3",@"caf"];
    SystemSoundID theSoundID;
    for (int i = 0; i < typeArr.count; i ++){
        NSString *path = [[NSBundle mainBundle]pathForResource:soundNameStr ofType:typeArr[i]];
        if (path){
            OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &theSoundID);
            if (error == kAudioServicesNoError){
                AudioServicesPlaySystemSound(theSoundID);
                return;
            }else{
                NSLog(@"Failed to create sound ");
            }
        }else{
        }
    }
}
//仅 iPhone 可以 iPad 没有震动
+ (void)vibratePlay
{
    for (int i = 1; i < 3; i++){
        [self performSelector:@selector(deleteKeyClick) withObject:self afterDelay:i *.3f];
    }
}
//类方法不能调用实例方法
+ (void)deleteKeyClick{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
