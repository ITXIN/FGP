//
//  WaterWaveView.h
//  FGProject
//
//  Created by Bert on 16/2/2.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MyWaterView.h"

#import "WaterRippleView.h"
/**
 *  绘制了图片以及统计个数
 */
@interface WaterWaveView : UIView
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong)  UILabel *countLab;
@property (nonatomic, strong) WaterRippleView *myWaterView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *sailngImageView;

//公式中用到(起始幅度)
@property (assign, nonatomic) float wave;
//起始高度，y值
@property (assign, nonatomic) float waveHeight;
//w 频率
@property (assign, nonatomic) float w;

//公式中用到(起始相位)
@property (assign, nonatomic) float b;

/**
 *  水波球动画
 */
- (void)showAnimationOfWaterWave;
@end
