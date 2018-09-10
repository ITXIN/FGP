//
//  FGDiffcultyCandidateAnswerView.h
//  FGProject
//
//  Created by 鑫龙魂 on 2018/9/9.
//  Copyright © 2018年 bert. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGDiffcultyCandidateAnswerViewDelegate <NSObject>
@optional
- (void)didClickCandidateActionType:(MathSimpleOperationViewActionType)actionType;
- (void)challengeFailure;//挑战失败
@end

@interface FGDiffcultyCandidateAnswerView : UIView
@property (nonatomic, strong)  UIView *bgView;
@property (nonatomic,strong) NSMutableArray *candidateBtnArr;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,weak) id <FGDiffcultyCandidateAnswerViewDelegate> delegate;
- (void)setupAnswerModel:(FGMathAnswerOptionsModel*)answerOptionModel;

@end
