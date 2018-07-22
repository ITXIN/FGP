//
//  OperatorView.m
//  FGProject
//
//  Created by XL on 15/7/2.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "FGSimpleOperationContentView.h"
@implementation FGSimpleOperationContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(OPERATOR_LEFT_MARGIN, 0, kScreenWidth/2-OPERATOR_LEFT_MARGIN,OPERATOR_HEIGHT)];
        [self addSubview:self.bgView];
    }
    return self;
}
#pragma mark --------model 的 setter 方法----
-(void)setQuestionModel:(FGMathOperationModel *)questionModel
{
    for (UIButton *btn in self.bgView.subviews){
        [btn removeFromSuperview];
    }
    //间距
    CGFloat padding = 0;
    NSInteger firstNum = questionModel.firstNum;
    //第二个数
    NSInteger secondNum = questionModel.secondNum;
    FGMathOperationManager *mathManager = [FGMathOperationManager shareMathOperationManager];
    MathOperationActionType operationType = questionModel.mathOperationActionType;
    UIImage *operationImage = [UIImage new];
    UIButton *preBtn;
    for (int i = 0; i < 4; i ++){
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
        }
        numAndOperBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [numAndOperBtn setBackgroundImage:operationImage forState:UIControlStateNormal];
        [self.bgView addSubview:numAndOperBtn];
        [numAndOperBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.mas_equalTo(padding);
            }else{
                make.left.mas_equalTo(preBtn.mas_right).offset(padding);
            }
            make.size.mas_equalTo(CGSizeMake(OPERATOR_HEIGHT, OPERATOR_HEIGHT));
            make.top.mas_equalTo(0);
        }];
        preBtn = numAndOperBtn;
    }//end for
    
}
@end
