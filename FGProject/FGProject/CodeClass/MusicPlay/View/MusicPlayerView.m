//
//  MusicPlayerView.m
//  FGProject
//
//  Created by Bert on 16/1/26.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "MusicPlayerView.h"
#import "FGMusicPlayerTimeModel.h"
@interface MusicPlayerView ()<MusicPlayerManagerDelegate>

@end
@implementation MusicPlayerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        UIVisualEffectView *effView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        [self addSubview:effView];
        [effView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        CGFloat timeLabWidth = 40.0;
        CGFloat timeLabHeight = frame.size.height/3;
        CGFloat leftMargin = 5.0;
        CGFloat pace = 5.0;
        CGFloat processWidth = frame.size.width - 2*timeLabWidth - 2*(pace + leftMargin);
        
        CGFloat processHeight = 10.0;
        UIColor *fontColor = [UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:1];
        UIFont *font = [UIFont systemFontOfSize:12.f];
        NSTextAlignment alignment = NSTextAlignmentCenter;
        
        self.currentTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, pace, timeLabWidth, timeLabHeight)];
        [self addSubview:self.currentTimeLab];
        self.currentTimeLab.text = @"00:00";
        CGFloat proceTop =  self.currentTimeLab.frame.origin.y + timeLabHeight/2 - pace/2;
        //
        self.processView = [[UISlider alloc]initWithFrame:CGRectMake(self.currentTimeLab.frame.size.width + self.currentTimeLab.frame.origin.x + pace, proceTop, processWidth, processHeight)];
        
        self.processView.value = 0.0;
        [self addSubview:self.processView];
        [self.processView addTarget:self action:@selector(processAction:) forControlEvents:UIControlEventValueChanged];
        self.processView.continuous = YES;//拖拽
        self.processView.minimumTrackTintColor = [UIColor colorWithRed:127/255.0 green:200/255.0 blue:255/255.0 alpha:1];
        
        self.allTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(self.processView.frame.size.width + self.processView.frame.origin.x + pace, pace, timeLabWidth, timeLabHeight)];
        [self addSubview:self.allTimeLab];
        self.allTimeLab.text = @"00:00";

        self.currentTimeLab.font = font;
        self.allTimeLab.font = font;
        
        self.currentTimeLab.textColor = fontColor;
        self.allTimeLab.textColor = fontColor;
        
        self.currentTimeLab.textAlignment = alignment;
        self.allTimeLab.textAlignment = alignment;
        
        CGFloat btnTopMar = 10.0;
         CGFloat btnTopMargin = frame.size.height/3 + btnTopMar;
        CGFloat btnW = frame.size.height/3*2 - 2*btnTopMar;
        CGFloat btnLeftW = btnW - 10;
        CGFloat btnPace = 40;
       
        _playBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        _playBtn.frame=CGRectMake(frame.size.width/2 - btnW/2, btnTopMargin, btnW, btnW);
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"ic_play_click"] forState:UIControlStateNormal];
        [self addSubview:_playBtn];
        
        _beforeBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        _beforeBtn.frame=CGRectMake(_playBtn.frame.origin.x - btnPace - btnLeftW, btnTopMargin + 5, btnLeftW, btnLeftW);
        [_beforeBtn setBackgroundImage:[UIImage imageNamed:@"ic_pre_click"] forState:UIControlStateNormal];
        [self addSubview:_beforeBtn];
        
        _nextBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        _nextBtn.frame=CGRectMake(_playBtn.frame.size.width + _playBtn.frame.origin.x + btnPace, btnTopMargin + 5, btnLeftW, btnLeftW);
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"ic_next_click"] forState:UIControlStateNormal];
        [self addSubview:_nextBtn];
        
        _beforeBtn.tag = MusicPlayTypeBefore;
        _playBtn.tag = MusicPlayTypePlay;
        _nextBtn.tag = MusicPlayTypeNext;
        [_beforeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.playerManager = [MusicPlayerManager shareMusicPlayerManager];
        self.playerManager.delegate = self;

        @weakify(self);
        self.playerManager.musicManagerTimeBlock = ^(FGMusicPlayerTimeModel *timeModel) {
            @strongify(self);

            [self.currentTimeLab setText:timeModel.currentTime];
            [self.allTimeLab setText:timeModel.durationTime];
            [self.processView setValue:timeModel.processValue animated:YES];
            
        };

    }
    return self;
}

//- (UIImage *)blurryImage:(UIImage *)image  withBlurLevel:(CGFloat)blur
//{
//    CIImage *inputImage = [CIImage imageWithCGImage:image.CGImage];
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"                           keysAndValues:kCIInputImageKey, inputImage,                                         @"inputRadius", @(blur),nil];
//    CIImage *outputImage = filter.outputImage;
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef outImage = [context createCGImage:outputImage                                      fromRect:[outputImage extent]];
//    return [UIImage imageWithCGImage:outImage];
//}
- (void)updateButtonImage:(UIButton*)sender imageName:(NSString *)imageName{
    
    [sender setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}
#pragma mark - MusicPlayerManagerDelegate
- (void)musicManagerIndex:(NSInteger)index{
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentPlayMusicIndex:)])
    {
        [self.delegate currentPlayMusicIndex:index];
    }
}

#pragma mark -
#pragma mark --- 设置数据
- (void)setupPlayerDataArr:(NSArray *)arr
{
    [self.playerManager setupMusicWithMusicDataArr:arr];
}

- (void)setPlayerWithMusicIndex:(NSInteger)index
{
    [self.playerManager setPlayerWithMusicIndex:index];
    [self pauseMusic];
}

- (void)pauseMusic{
    [self.playerManager pause];
    [self updateButtonImage:self.playBtn imageName:@"ic_play_click"];
}
- (void)playMusic{
    @weakify(self);
    [self.playerManager play:^{
        @strongify(self);
        [self updateButtonImage:self.playBtn imageName:@"ic_pause_click"];
    }];
    
}

- (void)btnClick:(UIButton *)btn
{
    [[SoundsProcess shareInstance]playSoundOfTock];
    if (btn.tag != MusicPlayTypePlay){
        [self updateButtonImage:self.playBtn imageName:@"ic_pause_click"];
    }
    switch (btn.tag) {
        case MusicPlayTypeBefore:
        {
            [self.playerManager beforeMusic];
              break;
        }
        case MusicPlayTypePlay:
        {
            if (self.playerManager.isPlay){
                [self pauseMusic];
            }else{
                [self playMusic];
            }
            break;
        }
        case MusicPlayTypeNext:
        {
             [self.playerManager nextMusic];
            break;
        }
            
        default:
            break;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(musicPlayViewActionType:)])
    {
        [self.delegate musicPlayViewActionType:btn.tag];
    }
}

- (void)processAction:(id<NSObject>)sender
{
    UISlider *slider = (UISlider *)sender;

    [self.playerManager playWithProgressValue:slider.value*self.playerManager.durationTime];
    [self pauseMusic];
    [self playMusic];
    if (slider == self.processView)
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(progressGerstureWithlocation:)])
        {
            [self.delegate progressGerstureWithlocation:slider.value];
        }
    }
}

@end
