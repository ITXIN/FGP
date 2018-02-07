//
//  ViewController.h
//  FGProject
//
//  Created by XL on 15/6/30.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  简单题目的详情页面
 *
 */
#import "FGMathBaseViewController.h"
@interface FGSimpleViewController : FGMathBaseViewController
//接收题目的运算符
@property (nonatomic,assign) MathOperationActionType mathOperationActionType;
@end

