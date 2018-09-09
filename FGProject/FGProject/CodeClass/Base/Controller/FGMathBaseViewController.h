//
//  FGMathBaseViewController.h
//  FGProject
//
//  Created by avazuholding on 2017/11/14.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGBaseViewController.h"
@class CircleView;
@class TooltipForAnswerView;
#import "TooltipForAnswerView.h"
@interface FGMathBaseViewController : FGBaseViewController
@property (nonatomic,strong) FGMathOperationManager *mathManager;
@property (nonatomic,strong) TooltipForAnswerView *toolView;
@property (nonatomic,strong) CircleView *circleView;

- (void)updatCircleviewData;//更新波的高度
- (void)showCircleAnimationOfWaterWave;
@end
