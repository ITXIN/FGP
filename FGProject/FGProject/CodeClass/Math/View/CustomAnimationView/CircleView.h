//
//  CircleView.h
//  FGProject
//
//  Created by Bert on 16/2/4.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterWaveView.h"
/**
 *  波圈
 */
@interface CircleView : UIView
@property (nonatomic,strong) WaterWaveView *waterWaveView;

/**
 *  绘制波圈
 *
 *  @param frame  frame
 */
- (void)drawCircleWithFrame:(CGRect)frame;

- (void)circleViewWillApper;

- (void)circleViewWillDisapper;

- (void)updatCircleviewData;

@end
