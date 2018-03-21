//
//  OperatorView.h
//  FGProject
//
//  Created by XL on 15/7/2.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "QuestionModel.h"
/**
 *  运算图片的视图
 */
@interface FGSimpleOperationContentView : UIView
//大的背景视图,方便修改
@property (nonatomic, strong)  UIView *bgView;
//-(void)setQuestionModel:(QuestionModel *)questionModel;
-(void)setQuestionModel:(FGMathOperationModel *)questionModel;
@end
