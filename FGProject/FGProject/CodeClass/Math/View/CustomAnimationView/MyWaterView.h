//
//  MyWaterView.h
//  WaterVavesDemo
//
//  Created by Bert on 16/2/1.
//  Copyright © 2016年 Bert. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  绘制水波
 */
@interface MyWaterView : UIView

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

@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSTimer *timer;

@end
