//
//  AnswerOptionView.m
//  FGProject
//
//  Created by XL on 15/7/8.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "FGSimpleOperationView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "FGClickRandomAnswerCountModel.h"
#import "FGMathAnswerOptionsModel.h"
@interface FGSimpleOperationView ()
{
    FGClickRandomAnswerCountModel *clickRandomCounModel;
}
@property (nonatomic,strong ) FIRDatabaseReference *dataBaseRef;//存字符串
@end
@implementation FGSimpleOperationView

- (instancetype)initWithFrame:(CGRect)frame operationType:(MathOperationActionType)operationType{
    self = [super initWithFrame:frame];
    if (self){
        //初始化
        self.answerOptionArr = [NSMutableArray array];
        self.mathOperationActionType = operationType;
        _bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bigView.userInteractionEnabled = YES;
        [self addSubview:_bigView];
        
        //添加手势
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMenu)];
        [_bigView addGestureRecognizer:tapR];
        
        //数字按钮
        NSString *btnStr1 = @"wenhao.png";
        UIImage *btnBackgImg = [UIImage imageNamed:btnStr1];
        
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake((kScreenWidth)/2+5, (kScreenHeight - QUESTION_MARK_HEIGHT)/2, QUESTION_MARK_HEIGHT, QUESTION_MARK_HEIGHT);
        [_button setBackgroundImage:btnBackgImg forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(showMenu) forControlEvents:(UIControlEventTouchUpInside)];
        [_bigView addSubview:_button];
        
        self.candidateBtnArr = [NSMutableArray array];
        for (int i = 0; i < 4; i ++){//候选答案
            UIButton *candidateBtn =  [UIButton buttonWithType:UIButtonTypeSystem];
            [_bigView addSubview:candidateBtn];
            [self.candidateBtnArr addObject:candidateBtn];
        }
        //运算的式子
        _operView = [[FGSimpleOperationContentView alloc]initWithFrame:CGRectMake(0, (kScreenHeight - QUESTION_MARK_HEIGHT)/2, kScreenWidth/2, OPERATOR_HEIGHT)];
        [_bigView  addSubview:_operView];
    }
    return self;
}

#pragma mark -
#pragma mark --- 数据上传 Firebase
- (void)setupPostDataToFireBase{
    NSString *adidStr = [FLDeviceUID uid];
    self.dataBaseRef = [[FIRDatabase database]referenceFromURL:FIREBASE_DATABASE_URL];
    self.dataBaseRef = [[[self.dataBaseRef child:adidStr]child:FIREBASE_DATABASE_CATEGORY_MATH] child:FIREBASE_DATABASE_CATEGORY_MATH_SIMPLE];
    self.dataBaseRef = [self.dataBaseRef child:[NSString stringWithFormat:@"%@",[FGProjectHelper logTimeStringFromDate:[NSDate date]]]];
}

#pragma mark -
#pragma mark --- postDataToFireBase
- (void)postDataToFireBaseWithClickQuestionModel:(FGClickRandomAnswerCountModel*)clickModel{
    NSString *dateStr = [FGProjectHelper logTimeStringFromDate:[NSDate date]];
    NSDictionary *dic = [FGProjectHelper postDataWithClickRandomModel:clickModel];
    [[self.dataBaseRef child:dateStr] updateChildValues:dic withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if (error) {
            return ;
        }
    }];
}

#pragma mark ------产生运算式------
- (void)operationSubjectByQuestionModel:(FGMathOperationModel *)questionModel{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_operView setQuestionModel:questionModel];
        [self setValueForBtnWithQuestionModel:questionModel];
        [self showMenu];
    });
}

#pragma mark --------对button 进行赋值---- 随机答案
- (void)setValueForBtnWithQuestionModel:(FGMathOperationModel *)questModel{
    //产生随机答案
    FGMathAnswerOptionsModel *answerModle = [[FGMathOperationManager shareMathOperationManager]generateRandomAnswerNum:questModel.answerNum];
    [self.answerOptionArr removeAllObjects];
    [self.answerOptionArr addObject:answerModle.firstNum];
    [self.answerOptionArr addObject:answerModle.secondNum];
    [self.answerOptionArr addObject:answerModle.thirdNum];
    [self.answerOptionArr insertObject:answerModle.answerNum atIndex:answerModle.answerIndex];
    
    for (int i = 0; i < self.answerOptionArr.count; i ++){
        [self setButtonView:self.candidateBtnArr[i] title:self.answerOptionArr[i] backgroundColor:0 green:0 blue:0];
        if (i == answerModle.answerIndex){
            UIButton *anwerBtn = (UIButton *)self.candidateBtnArr[i];
            anwerBtn.tag = MathSimpleOperationViewActionTypeAnswer;
        }
    }
}

#pragma mark-----CAAnimation
- (void)viewCAAnimation:(UIView *)view duration:(CGFloat )duration keyPath:(NSString *)keyPath toValue:(NSNumber *)number{
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = number;
    animation.duration = 0.8;
    [view.layer addAnimation:animation forKey:nil];
}

#pragma mark-----Animation 子菜单动画
- (void)viewAnimation:(UIView *)view duration:(CGFloat )duration x:(CGFloat)x y:(CGFloat)y alpha:(CGFloat)alpha{
    [UIView animateWithDuration:duration animations:^{
        [self viewCAAnimation:view duration:duration keyPath:@"transform.rotation.z" toValue:[NSNumber numberWithFloat:(-M_PI/180 *360)]];
        view.center = CGPointMake(self.button.center.x + x, self.button.center.y + y);
        view.alpha = alpha;
    } completion:nil];
}

#pragma mark--------设置button的属性
//标题  大小 初始位置 响应时间
- (void)setButtonView:(UIButton *)buttton title:(NSString *)title backgroundColor:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue{
    UIFont *font = [UIFont systemFontOfSize:50];
    NSTextAlignment center = NSTextAlignmentCenter;
    buttton.titleLabel.font =font;
    buttton.titleLabel.textAlignment = center;
    buttton.alpha = 0;
    [buttton setTitle:title forState:(UIControlStateNormal)];
    buttton.frame = CGRectMake(kScreenWidth/2-kScreenHeight/5, kScreenHeight/2-kScreenHeight/5, kScreenHeight/5, kScreenHeight/5);
    //#warning 发现调整 frame 可以改变动画效果
    buttton.center = CGPointMake(self.button.center.x, self.button.center.y);
    //tag值默认为0
    buttton.tag = 1000;
    buttton.backgroundColor = [UIColor blackColor];
    buttton.layer.cornerRadius = (buttton.frame.size.height)/2;
    buttton.layer.masksToBounds = YES;
    buttton.tintColor = [UIColor whiteColor];
    [buttton addTarget:self action:@selector(answerBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
}

#pragma mark-------对题目准确性的判断------
- (void)answerBtnAction:(UIButton *)button{
    if(button.tag == MathSimpleOperationViewActionTypeAnswer){
        if (self.delegate && [self.delegate respondsToSelector:@selector(simpleViewOperationActionType:)]) {
            [self.delegate simpleViewOperationActionType:MathSimpleOperationViewActionTypeAnswer];
        }
    }else{
        //统计,分析点击情况
        if (self.delegate && [self.delegate respondsToSelector:@selector(simpleViewOperationActionType:)]) {
            [self.delegate simpleViewOperationActionType:MathSimpleOperationViewActionTypeOperation];
        }
    }
}

#pragma mark------显示菜单栏
- (void)showMenu{
    [self viewCAAnimation:_button duration:0.8 keyPath:@"transform.rotation.z" toValue:[NSNumber numberWithFloat:(M_PI/180 *360)]];
    CGFloat topMargin = ANSWEROPTION_TOPMARGIN;
    CGFloat btnWH = ANSWEROPTION_BTN_WIDTH;
    
    //不能使用循环,可能由于动画时间太短或其他原因.
    [self viewAnimation:self.candidateBtnArr[0] duration:0.4 x:0 y:-(kScreenHeight/2 - topMargin - btnWH/2) alpha:1.0];
    [self viewAnimation:self.candidateBtnArr[1] duration:0.7 x:(kScreenHeight/2 - topMargin - btnWH/2)/1.414 y:-(kScreenHeight/2 - topMargin - btnWH/2)/2 alpha:1.0];
    [self viewAnimation:self.candidateBtnArr[2] duration:0.9 x:(kScreenHeight/2 - topMargin - btnWH/2)/1.414 y:(kScreenHeight/2 - topMargin - btnWH/2)/2 alpha:1.0];
    [self viewAnimation:self.candidateBtnArr[3] duration:1.1 x:0 y:(kScreenHeight/2 - topMargin - btnWH/2) alpha:1.0];
}

#pragma mark-----点击屏幕子菜单收回
- (void)hiddenMenu{
    [self viewCAAnimation:_button duration:0.8 keyPath:@"transform.rotation.z" toValue:[NSNumber numberWithFloat:(-M_PI/180 *360)]];
    for (int i = 0; i < self.candidateBtnArr.count; i ++){
        [self viewAnimation:self.candidateBtnArr[i] duration:0.4 + i*0.3 x:0 y:0 alpha:0.0];
    }
}

@end
