//
//  FGRootView.h
//  FGProject
//
//  Created by pingan on 2018/8/7.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGBaseView.h"
@class CARadarView;
@class WaterRippleView;
@interface FGRootView : FGBaseView
@property (nonatomic,strong) CARadarView *radarView;
//太阳图片
@property (nonatomic, strong) UIImageView *sunImgView;
@property (nonatomic, strong) WaterRippleView *myWaterView;
//公式中用到(起始幅度)
@property (assign, nonatomic) float wave;
//起始高度，y值
@property (assign, nonatomic) float waveHeight;
//w 频率
@property (assign, nonatomic) float w;
//公式中用到(起始相位)
@property (assign, nonatomic) float b;

- (void)showWaterAnimation;
- (void)hiddenWaterAnimation;
@end
