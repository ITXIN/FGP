//
//  ChoiceView.h
//  FGProject
//
//  Created by XL on 15/7/8.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterWaveView.h"
#import "CircleView.h"

#import "FGBaseView.h"
@protocol FGMathRootViewDelegate <NSObject>
@optional
- (void)choiceBtnAction:(MathRootViewActionType)mathRootViewActionType;
@end

@interface FGMathRootView : FGBaseView<UIAlertViewDelegate>
//加减乘除
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *subtractBtn;
@property (nonatomic, strong) UIButton *multiplyBtn;
@property (nonatomic, strong) UIButton *divideBtn;
@property (nonatomic, strong) UIButton *reduceBtn;
//做的题目数量
@property (nonatomic, strong) UIButton *countBtn;
//综合练习
@property (nonatomic, strong) UIButton *compreBtn;
@property (nonatomic,weak) id <FGMathRootViewDelegate> delegate;

@end
