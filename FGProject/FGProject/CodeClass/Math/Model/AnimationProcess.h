//
//  AnimationProcess.h
//  FGProject
//
//  Created by Bert on 16/1/11.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  动画处理
 */
@interface AnimationProcess : NSObject
/**
 *  方向向上的弹簧动画
 *
 *  @param view      view
 *  @param upHeight 向上偏移高度
 */
+ (void)springAnimationProcessWithView:(UIView *)view upHeight:(CGFloat)upHeight;
/**
 *  放缩效果
 *
 *  @param view view
 */
+ (void)scaleAnmiationProcessWithView:(UIView *)view;
@end
