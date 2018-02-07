//
//  MusicPlayerManage.m
//  FGProject
//
//  Created by Bert on 16/1/26.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "MusicPlayerManager.h"
#import "FGMusicPlayerTimeModel.h"
@implementation MusicPlayerManager
{
    AVAudioPlayer *musicPlayer;
    NSMutableArray *musicArray;//音乐数组
}

+ (instancetype)shareMusicPlayerManager
{
    static MusicPlayerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
        manager.timeModel = [[FGMusicPlayerTimeModel alloc]init];
        [manager startTimer];
        
    });
    return manager;
}
//设置本地的
- (void)setUpMusic
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager subpathsAtPath:bundlePath];
    musicArray = [[NSMutableArray alloc] init];
    for (NSString *file in fileList){
        NSString *path = [bundlePath stringByAppendingPathComponent:file];
        if (([path containsString:@".wav"] || [path containsString:@".mp3"]) && [[fileManager attributesOfItemAtPath:path error:nil] fileSize]/1024.0/1024.0 > 0.2 )//过滤小文件以及音乐格式
        {
            [musicArray addObject:path];
        }
    }
    int index = arc4random() %(musicArray.count - 1 - 0 + 1) + 0;
    self.currendIndex = index;
    [self setPlayerWithLocalMusicIndex:self.currendIndex];
    
    //设置锁屏仍能继续播放
    //    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    //    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
}
// 设置网络的
- (void)setupMusicWithMusicDataArr:(NSArray *)arr
{
    [musicArray removeAllObjects];
    musicArray = [NSMutableArray arrayWithArray:arr];
    self.currendIndex = 0;
    [self setPlayerWithMusicIndex:self.currendIndex];
}
//网络 music
- (void)setPlayerWithMusicIndex:(NSInteger)index
{
    if (musicArray.count == 0 || index >= musicArray.count) {
        FGLOG(@"音乐播放数组下标越界");
        return;
    }
    [self setupTimerDistantPast];
    musicPlayer  = nil;
    NSString *musicPath = musicArray[index];
    NSURL *musicURL = [[NSURL alloc]initWithString:musicPath];
    NSData * audioData = [NSData dataWithContentsOfURL:musicURL];
    //将数据保存到本地指定位置
    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , musicPath];
    [audioData writeToFile:filePath atomically:YES];
    
    NSError *myError = nil;
    //创建播放器
    musicPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&myError];
    if (musicPlayer == nil)
    {
        NSLog(@"error === %@",[myError description]);
    }
    musicPlayer.delegate = self;
    musicPlayer.numberOfLoops = 0;
    [musicPlayer setVolume:0.5];   //设置音量大小
    //musicPlayer.numberOfLoops = -1;//设置音乐播放次数  -1为一直循环
    [musicPlayer prepareToPlay];
    [self pause];
    
}

//本地音乐
- (void)setPlayerWithLocalMusicIndex:(NSInteger)index
{
    musicPlayer  = nil;
    NSString *musicPath = musicArray[index];
    if ([[NSFileManager defaultManager] fileExistsAtPath:musicPath])
    {
        NSURL *musicURL = [NSURL fileURLWithPath:musicPath];
        NSError *myError = nil;
        //创建播放器
        musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:&myError];
        if (musicPlayer == nil)
        {
            NSLog(@"error === %@",[myError description]);
        }
        musicPlayer.delegate = self;
        musicPlayer.numberOfLoops = 0;
        [musicPlayer setVolume:0.5];   //设置音量大小
        //musicPlayer.numberOfLoops = -1;//设置音乐播放次数  -1为一直循环
        [musicPlayer prepareToPlay];
        [self pause];
        NSLog(@"-----new music ");
    }
}

#pragma mark -
- (void)startTimer{
    FGLOG(@"");
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updatePlayingProcess) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer setFireDate:[NSDate distantFuture]];
}
//开启
- (void)setupTimerDistantPast{
    [self setDurationTimeWithDuration:self.durationTime];
    [self.timer setFireDate:[NSDate distantPast]];
}
//关闭
- (void)setupTimerDistantFuture{
    [self setDurationTimeWithDuration:self.durationTime];
    [self.timer setFireDate:[NSDate distantFuture]];
}
- (void)updatePlayingProcess{
    FGLOG(@"");
    NSInteger currentTime = self.currentTime;
    CGFloat process = self.currentTime/self.durationTime;
    
    NSInteger currMin = currentTime/60;
    NSInteger currSec = currentTime%60;

    NSString *currMinStr = nil;
    NSString *currSecStr = nil;
    if (currMin >= 10){
        currMinStr = [NSString stringWithFormat:@"%ld:",currMin];
    }else{
        currMinStr = [NSString stringWithFormat:@"0%ld:",currMin];
    }
    
    if (currSec >= 10){
        currSecStr = [NSString stringWithFormat:@"%ld",currSec];
    }else{
        currSecStr = [NSString stringWithFormat:@"0%ld",currSec];
    }
    
    self.timeModel.processValue = process;
    self.timeModel.currentTime = [NSString stringWithFormat:@"%@%@",currMinStr,currSecStr];
    self.musicManagerTimeBlock(self.timeModel);
    
}

#pragma mark -
- (void)play:(void (^)(void))callblock
{
    [musicPlayer play];
    [self setupTimerDistantPast];
    callblock();
    FGLOG(@"-----play music ");
}
- (void)pause
{
    
    [musicPlayer pause];
    [self setupTimerDistantFuture];
    [self updatePlayingProcess];//第一次进入页面显示时间
    FGLOG(@"-----pause music ");
}
- (void)stop
{
    [musicPlayer stop];
    [self setupTimerDistantFuture];
    FGLOG(@"-----stop music ");
}
- (void)nextMusic
{
    FGLOG(@"-----next music ");
    self.currendIndex ++;
    [self changeMusicWithIndex:self.currendIndex];
    [self setupTimerDistantPast];
}
- (void)beforeMusic
{
    FGLOG(@"-----before music ");
    self.currendIndex --;
    [self changeMusicWithIndex:self.currendIndex];
    [self setupTimerDistantPast];
}
- (void)playWithProgressValue:(CGFloat)value
{
    FGLOG(@"-----playWithProgressValue ");
    musicPlayer.currentTime = value;
}

- (void)playFinsh
{
    FGLOG(@"-----playfinish ");
    self.currendIndex ++;
    [self changeMusicWithIndex:self.currendIndex];
}

- (void)setVolumeWithVolume:(float)volume
{
    musicPlayer.volume = volume;
}
//根据数组下标播放音乐
- (void)changeMusicWithIndex:(NSInteger)index
{
    [self stop];
    if (self.currendIndex >= [musicArray count]) {
        index = 0;
    }
    if (self.currendIndex <= -1) {
        index = [musicArray count] - 1;
    }
    self.currendIndex = index;
    if (![[NSString stringWithFormat:@"%@",musicArray[index]] containsString:@"http"]) {
        [self setPlayerWithLocalMusicIndex:self.currendIndex];
    }else
    {
        [self setPlayerWithMusicIndex:self.currendIndex];
    }
    [self play:^{
        
    }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(musicManagerIndex:)])
    {
        [self.delegate musicManagerIndex:self.currendIndex];
    }
    
}

- (BOOL)isPlay
{
    return musicPlayer.isPlaying;
}

- (CGFloat)currentTime
{
    return [musicPlayer currentTime];
}

- (CGFloat)durationTime
{
    CGFloat duration = [musicPlayer duration];
    
    return duration;
}

- (void)setDurationTimeWithDuration:(CGFloat)duration{
    NSInteger minute = duration/60;
    NSInteger second = duration - minute * 60;
    NSString *allMinuteStr = nil;
    NSString *allSecondStr = nil;
    if (minute >= 10)
    {
        allMinuteStr = [NSString stringWithFormat:@"%ld:",minute];
    }else
    {
        allMinuteStr = [NSString stringWithFormat:@"0%ld:",minute];
    }
    if (second >= 10)
    {
        allSecondStr = [NSString stringWithFormat:@"%ld",second];
    }else
    {
        allSecondStr = [NSString stringWithFormat:@"0%ld",second];
    }
    self.timeModel.durationTime = [NSString stringWithFormat:@"%@%@",allMinuteStr,allSecondStr];
    
}
#pragma mark -
#pragma mark --- 
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self playFinsh];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    FGLOG(@"-----player error %@",error);
}

@end
