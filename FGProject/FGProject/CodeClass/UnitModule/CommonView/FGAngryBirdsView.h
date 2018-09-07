//
//  FGAngryBirdsView.h
//  FGProject
//
//  Created by Bert on 2016/12/29.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGAngryBirdsView : UIView
//公式中用到(起始幅度)
@property (assign, nonatomic) float wave;
//判断加减
@property (assign, nonatomic) BOOL jia;
//幅度增长速度
@property (assign, nonatomic) float waveIncrease;
//幅度最小值
@property (assign, nonatomic) float waveMin;
//幅度最大值
@property (assign, nonatomic) float waveMax;
//波浪增幅的速度控制
@property (assign, nonatomic) float waveSpeed;
//起始高度，y值
@property (assign, nonatomic) float waveHeight;
//w 频率
@property (assign, nonatomic) float w;

//公式中用到(起始相位)
@property (assign, nonatomic) float b;

@property (nonatomic,strong) CAShapeLayer *bigBirdShapeLayer;

- (void)restartBirdsAnimation;//重新开始动画

@end
