//
//  FGMistakesOperationView.m
//  FGProject
//
//  Created by 鑫龙魂 on 2018/7/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGMistakesOperationView.h"

@implementation FGMistakesOperationView

-(void)initSubviews{
    [super initSubviews];
    
}

-(void)setQuestionModel:(FGMathOperationModel *)questionModel{
    for (UIButton *btn in self.bgView.subviews){
        [btn removeFromSuperview];
    }
    
    NSInteger firstNum = questionModel.firstNum;
    //第二个数
    NSInteger secondNum = questionModel.secondNum;
    FGMathOperationManager *mathManager = [FGMathOperationManager shareMathOperationManager];
    //    MathOperationActionType operationType = questionModel.mathOperationActionType;
    NSInteger count = 0;
    if (questionModel.operationLevel == MathOperationLevelTwo) {
        count = 5;
    }else if (questionModel.operationLevel == MathOperationLevelThird){
        count = 7;
    }
    
    UIImage *operationImage = [UIImage new];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < count; i ++){
        UIButton *numAndOperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        numAndOperBtn.tag = 100 + i;
        if (i == 0){
            operationImage = [mathManager getOperationNumberImageWithNumber:firstNum];
        }else if (i == 1){
            if (questionModel.operationLevel == MathOperationLevelTwo) {
                operationImage = [mathManager getOperationImageWithOperationType: questionModel.mathOperationActionType];
            }else if (questionModel.operationLevel == MathOperationLevelThird){
                operationImage = [mathManager getOperationImageWithOperationType:questionModel.firstOperationType];
            }
        }else if (i == 2){
            operationImage = [mathManager getOperationNumberImageWithNumber:secondNum];
        }else if(i == 3){
            if (questionModel.operationLevel == MathOperationLevelTwo) {
                operationImage = [UIImage imageNamed:@"dengyu"];
            }else if (questionModel.operationLevel == MathOperationLevelThird){
                operationImage = [mathManager getOperationImageWithOperationType:questionModel.secondOperationType];
            }
        }else if (i ==4){
            if (questionModel.operationLevel == MathOperationLevelTwo) {
                operationImage = [UIImage imageNamed:@"wenhao"];
            }else if (questionModel.operationLevel == MathOperationLevelThird){
                
                operationImage = [mathManager getOperationNumberImageWithNumber:questionModel.thirdNum];
            }
            
        }else if (i == 5){
            operationImage = [UIImage imageNamed:@"dengyu"];
            
        }else if(i == 6){
            operationImage = [UIImage imageNamed:@"wenhao"];
        }
        
        numAndOperBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [numAndOperBtn setBackgroundImage:operationImage forState:UIControlStateNormal];
        [self.bgView addSubview:numAndOperBtn];
        [arr addObject:numAndOperBtn];
        
        [numAndOperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView).offset(10);
            make.bottom.equalTo(self.bgView).offset(-10);
            make.centerY.equalTo(self.bgView);
        }];
    }
    
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
}

@end
