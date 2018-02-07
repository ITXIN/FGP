//
//  MusicPlayerView.h
//  FGProject
//
//  Created by Bert on 16/1/26.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnumHeader.h"
#import "MusicPlayerManager.h"
@protocol MusicPlayerViewDelegate <NSObject>
@optional
/**
 *  播放按钮
 *
 *  
 */
- (void)musicPlayViewActionType:(MusicPlayType)musicPlayType;
/**
 *  进度条处理
 *
 *  @param locationX 拖拽或点击位置
 */
- (void)progressGerstureWithlocation:(CGFloat )locationX;
- (void)currentPlayMusicIndex:(NSInteger)index;
@end
@interface MusicPlayerView : UIView
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *beforeBtn;
@property (strong, nonatomic) UIButton *nextBtn;
@property (nonatomic,strong) UISlider *processView;
@property (nonatomic,strong) UILabel *currentTimeLab;
@property (nonatomic,strong) UILabel *allTimeLab;
@property (nonatomic,assign) id <MusicPlayerViewDelegate> delegate;
@property (nonatomic,strong) MusicPlayerManager *playerManager;

- (void)setupPlayerDataArr:(NSArray *)arr;
- (void)setPlayerWithMusicIndex:(NSInteger)index;
@end
