//
//  ChoiceView.m
//  FGProject
//
//  Created by XL on 15/7/8.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "FGMathRootView.h"
#define TAG 1000

#import "WaterWaveView.h"
#import "MyWaterView.h"
@implementation FGMathRootView

- (void)initSubviews{
    [super initSubviews];
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/3];
    basicAnim.duration = 2.0;
    basicAnim.autoreverses = YES;
    basicAnim.repeatCount = HUGE_VAL;
    basicAnim.removedOnCompletion = NO;
    
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/13];
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/14];
    
    NSArray *tagArr = @[@(MathRootViewActionTypeSubtract),@(MathRootViewActionTypeAdd),@(MathRootViewActionTypeMultiply),@(MathRootViewActionTypeDivide),@(MathRootViewActionTypeSun),@(MathRootViewActionTypeCompre)];
    NSArray *imageNameArr = @[@"jianhao-01",@"jiahao-02.png",@"chenghao-01",@"chuhao-01",@"taiyang-03",@"zhonghe-01.png"];
    
    CGFloat operationButtonWidth = kScreenWidth/7;
    CGSize operationSize = CGSizeMake(operationButtonWidth, operationButtonWidth);
    CGFloat topMar = 20;
    CGFloat btnSpace = 20.0;
    for (NSInteger i = 0 ; i < tagArr.count; i ++) {
        UIButton *tempBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bgView addSubview:btn];
            btn.tag =  [(NSNumber*)tagArr[i] integerValue];
            [btn setBackgroundImage:[UIImage imageNamed:imageNameArr[i]] forState:UIControlStateNormal];
            [btn.layer addAnimation:basicAnim forKey:@"transform.rotation.z"];
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        MathRootViewActionType type = tempBtn.tag;
        switch (type) {
            case MathRootViewActionTypeSubtract:
            {
                self.subtractBtn = tempBtn;
                [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.bgView.mas_centerY).offset(-btnSpace*2);
                    make.right.equalTo(self.bgView.mas_centerX).offset(-btnSpace/2);
                    make.size.mas_equalTo(operationSize);
                }];
                break;
            }
            case MathRootViewActionTypeAdd:
            {
                self.addBtn = tempBtn;
                [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(self.subtractBtn.mas_left).offset(-btnSpace);
                    make.top.mas_equalTo(self.subtractBtn.mas_bottom).offset(btnSpace);
                    make.size.mas_equalTo(operationSize);
                }];
                
                break;
            }
                
            case MathRootViewActionTypeMultiply:
            {
                self.multiplyBtn = tempBtn;
                [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.bgView.mas_centerX).offset(btnSpace/2);
                    make.top.mas_equalTo(self.subtractBtn);
                    make.size.mas_equalTo(operationSize);
                }];
                break;
            }
            case MathRootViewActionTypeDivide:
            {
                self.divideBtn = tempBtn;
                [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.multiplyBtn.mas_right).offset(btnSpace);
                    make.top.mas_equalTo(self.addBtn);
                    make.size.mas_equalTo(operationSize);
                }];
                break;
            }
                
            case MathRootViewActionTypeSun:
            {
                
//                self.sunBtn = tempBtn;
//                [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.right.mas_equalTo(self.subtractBtn.mas_left).offset(-2*btnSpace);
//                    make.top.mas_equalTo(topMar/2);
//                    make.size.mas_equalTo(CGSizeMake(kScreenWidth/10, kScreenWidth/10));
//                }];
                
                break;
            }
            case MathRootViewActionTypeCompre:
            {
                self.compreBtn = tempBtn;
                [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.subtractBtn.mas_bottom).offset(10);
                    make.size.mas_equalTo(operationSize);
                    make.centerX.equalTo(self.bgView);
                }];
                tempBtn.backgroundColor = [UIColor whiteColor];
                tempBtn.layer.cornerRadius = operationButtonWidth/2;
                tempBtn.layer.masksToBounds = YES;
                break;
            }
            default:
                break;
        }
    }
    
    
    //隐藏接口删除数据
//    UILongPressGestureRecognizer *longPGR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clearPastData:)];
//    longPGR.minimumPressDuration = 4.0;
//    [self.sunBtn addGestureRecognizer:longPGR];
}

#pragma mark -
#pragma mark --- 统计以及太阳
- (void)btnAction:(UIButton *)btn{
    [AnimationProcess springAnimationProcessWithView:btn upHeight:30.f];
    [[SoundsProcess shareInstance]playSoundOfTock];
}
- (void)clickAction:(UIButton *)btn{
    [[SoundsProcess shareInstance]playSoundOfTock];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceBtnAction:)])
    {
        [self.delegate choiceBtnAction:btn.tag];
    }
}

#pragma mark -
#pragma mark --- 清理数据
- (void)clearPastData:(UILongPressGestureRecognizer *)tap{
    NSLog(@"-----sun long state %ld",tap.state);
    if (tap.state == UIGestureRecognizerStateBegan){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"清除题目统计"
                                                        message:@"是否确定清除题目统计,如果确认清理,所做题目统计将不能找回."
                                                       delegate:self
                                              cancelButtonTitle:@"YES"
                                              otherButtonTitles:@"NO",nil];
        [alert show];
        
        return;
        
    }else{
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"-----index %ld",buttonIndex);
    if (buttonIndex == 0){
        //题目统计都是一个,没有区分难易程度.
        //清理
        [HasDoneOperation clearHadDoneDataWithDifcultyLevelMark:EASY_STAR_NUMBER_MARK];
        [HasDoneOperation clearHadDoneDataWithDifcultyLevelMark:MEDIUM_STAR_NUMBER_MARK];
        [HasDoneOperation clearHadDoneDataWithDifcultyLevelMark:HARD_STAR_NUMBER_MARK];
        
        FGDateSingle *single = [FGDateSingle shareInstance];
        [[NSUserDefaults standardUserDefaults] setValue:0 forKey:[single curretDate]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.countBtn setTitle:@"今天0道" forState:UIControlStateNormal];
    }else{
        
    }
    
}

@end
