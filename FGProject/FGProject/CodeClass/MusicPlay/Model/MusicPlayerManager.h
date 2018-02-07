//
//  MusicPlayerManage.h
//  FGProject
//
//  Created by Bert on 16/1/26.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class FGMusicPlayerTimeModel;
typedef void (^FGMusicManagerTimeBlock)(FGMusicPlayerTimeModel *timeModel);
@protocol MusicPlayerManagerDelegate <NSObject>
- (void)musicManagerIndex:(NSInteger)index;
//- (void)musicManagerTimeModel;
@end


@interface MusicPlayerManager : NSObject<AVAudioPlayerDelegate>
@property (nonatomic,weak) id<MusicPlayerManagerDelegate> delegate;
@property (nonatomic,copy) FGMusicManagerTimeBlock musicManagerTimeBlock;

@property (nonatomic,assign) CGFloat currentTime;
@property (nonatomic,assign) CGFloat durationTime;
@property (nonatomic,assign) NSInteger currendIndex;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) FGMusicPlayerTimeModel *timeModel;

//- (void)startTimer;
- (void)play:(void (^)(void))callblock;//播放
- (void)pause;//暂停
- (void)stop;//停止
- (void)nextMusic;//下一首
- (void)beforeMusic;//上一首
- (void)playWithProgressValue:(CGFloat)value;//根据时间跳转
- (void)changeMusicWithIndex:(NSInteger)index;//根据下标播放音乐
- (void)playFinsh;//播放完成
- (BOOL)isPlay;
- (void)setVolumeWithVolume:(float)volume;
- (void)setUpMusic;//本地的音乐
+ (instancetype)shareMusicPlayerManager;
- (void)setupMusicWithMusicDataArr:(NSArray *)arr;//设置网络数据
//网络 music
- (void)setPlayerWithMusicIndex:(NSInteger)index;
@end
