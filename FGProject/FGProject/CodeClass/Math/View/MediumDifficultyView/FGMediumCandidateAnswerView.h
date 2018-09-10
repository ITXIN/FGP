//
//  MediumCandidateAnswerView.h
//  FGProject
//
//  Created by Bert on 16/1/18.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  中等难度候选答案视图
 */
//@class MediumOperationModel;
@protocol FGMediumCandidateAnswerViewDelegate <NSObject>
@optional
- (void)didClickCandidateActionType:(MathOperationChooseResultType)actionType;
@end

@interface FGMediumCandidateAnswerView : UIView
@property (nonatomic, strong)  UIView *bgView;
@property (nonatomic,strong) NSMutableArray *candidateBtnArr;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,weak) id <FGMediumCandidateAnswerViewDelegate> delegate;
- (void)setupAnswerModel:(FGMathAnswerOptionsModel*)answerOptionModel;

@end
