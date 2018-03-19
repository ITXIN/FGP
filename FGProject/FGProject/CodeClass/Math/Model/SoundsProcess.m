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

+ (SoundsProcess *)shareInstance
{
    
    static SoundsProcess *sounds = nil;//声明一个全局的指针
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sounds = [[self alloc] init];
      NSString *state = [FGProjectHelper getDataWithKey:SOUND_PLAY_STATE_KEY];
        if (state) {
            if ([state isEqualToString:@"YES"]) {
                 sounds.isPlaySound = YES;
            }else if ([state isEqualToString:@"NO"]){
                 sounds.isPlaySound = NO;
            }
        }else{
          sounds.isPlaySound = YES;
        }
       
    });
    return sounds;
}
- (void)setIsPlaySound:(BOOL)isPlaySound{
    _isPlaySound = isPlaySound;
    if (isPlaySound) {
        [FGProjectHelper saveDataWithKey:SOUND_PLAY_STATE_KEY data:@"YES"];
    }else{
        [FGProjectHelper saveDataWithKey:SOUND_PLAY_STATE_KEY data:@"NO"];
    }
    
    
}

//点击声音
- (void)playSoundOfTock{
    if (self.isPlaySound) {
        [self playSoundWithNameStr:@"Tock"];
    }
}
//wonderful
- (void)playSoundOfWonderful{
    if (self.isPlaySound) {
        [self playSoundWithNameStr:@"wonderful"];
    }
}
//wrong
- (void)playSoundOfWrong{
    if (self.isPlaySound) {
        [self vibratePlay];
        [self playSoundWithNameStr:@"wrong"];
    }
}
//fireworks
- (void)playSoundOfFireworks{
    if (self.isPlaySound) {
        [self playSoundWithNameStr:@"fireworks-01"];
    }
}



- (void)playSoundWithNameStr:(NSString *)soundNameStr
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
- (void)vibratePlay
{
    for (int i = 1; i < 3; i++){
        [self performSelector:@selector(deleteKeyClick) withObject:self afterDelay:i *.3f];
    }
}
//类方法不能调用实例方法
- (void)deleteKeyClick{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

@end
