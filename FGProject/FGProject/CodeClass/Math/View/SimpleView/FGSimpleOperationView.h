/////
//  AnswerOptionView.h
//  FGProject
//
//  Created by XL on 15/7/8.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGSimpleOperationContentView.h"
#import "FGRewardsView.h"
#import "TooltipForAnswerView.h"
/**
 *  答案候选项
 */
//typedef void (^backToRootVCBlock) (void);


@protocol FGSimpleOperationViewDelegate <NSObject>

- (void)simpleViewOperationActionType:(MathSimpleOperationViewActionType)actionType;
@end
@interface FGSimpleOperationView : UIView

@property (nonatomic, assign) id <FGSimpleOperationViewDelegate> delegate;
//接收题目的运算符
@property (nonatomic,assign) MathOperationActionType mathOperationActionType;
//存放问题信息的字典
@property (nonatomic, strong) NSMutableDictionary *questionDic;
//大的背景
@property (nonatomic, strong) UIView *bigView;

//题目视图
@property (nonatomic, strong) FGSimpleOperationContentView *operView;
@property (nonatomic, strong) FGRewardsView *startView;
/**
 *  答案数字
 */
@property (nonatomic, strong) UIButton *button;//问号

@property (nonatomic,strong) NSMutableArray *candidateBtnArr;
@property (nonatomic,strong) NSMutableArray *answerOptionArr;

@property (nonatomic,strong) NSString *keySoundPath;
@property (nonatomic,strong) NSTimer *deleteTimer;

- (instancetype)initWithFrame:(CGRect)frame operationType:(MathOperationActionType)operationType;
//- (void)operationSubjectByQuestionModel:(QuestionModel*)questionModel;
- (void)operationSubjectByQuestionModel:(FGMathOperationModel *)questionModel;
@end
