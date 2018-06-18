//
//  WaterWaveView.h
//  FGProject
//
//  Created by Bert on 16/2/2.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyWaterView.h"
/**
 *  绘制了图片以及统计个数
 */
@interface WaterWaveView : UIView
@property (nonatomic,assign) NSInteger count;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) float waveHeight;
@property (nonatomic,strong)  UILabel *countLab;
@property (nonatomic,strong) MyWaterView *myWaterView;
@property (nonatomic, strong) UILabel *titleLab;
/**
 *  水波球动画
 */
- (void)showAnimationOfWaterWave;
@end
