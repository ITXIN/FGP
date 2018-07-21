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
    MathOperationActionType operationType = questionModel.mathOperationActionType;
    UIImage *operationImage = [UIImage new];
    UIButton *preBtn;
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 5; i ++){
        UIButton *numAndOperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        numAndOperBtn.tag = 100 + i;
        if (i == 0){
            operationImage = [mathManager getOperationNumberImageWithNumber:firstNum];
        }else if (i == 1){
            operationImage = [mathManager getOperationImageWithOperationType:operationType];
        }else if (i == 2){
            operationImage = [mathManager getOperationNumberImageWithNumber:secondNum];
        }else if (i == 3){
            operationImage = [UIImage imageNamed:@"dengyu"];
        }else{
           operationImage = [UIImage imageNamed:@"wenhao.png"];
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
        preBtn = numAndOperBtn;
    }//end for
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    
}
@end
