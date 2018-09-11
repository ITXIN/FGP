//
//  FGDiffcultyCandidateAnswerView.m
//  FGProject
//
//  Created by 鑫龙魂 on 2018/9/9.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGDiffcultyCandidateAnswerView.h"
#import "FGMathAnswerOptionsModel.h"
#import "FGDiffcultyCandidataAnswerButton.h"
@implementation FGDiffcultyCandidateAnswerView
{
    CGFloat btnWidth;
}

-(void)dealloc{

//    [self removeObserver];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        btnWidth = kScreenHeight/4;
        CGFloat btnHeight = kScreenHeight/4;
        
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,btnHeight)];
        [self addSubview:_bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.candidateBtnArr = [NSMutableArray array];
     
        for (int i = 0; i < 4; i ++){
            FGDiffcultyCandidataAnswerButton *buttton =  [[FGDiffcultyCandidataAnswerButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
            buttton.center = self.bgView.center;
            //tag值默认为0
            buttton.actionBtn.tag = MathOperationChooseResultTypeError;
            [buttton.actionBtn addTarget:self action:@selector(candidateBtnClick:) forControlEvents:UIControlEventTouchUpInside];

            [self.bgView addSubview:buttton];
            [self.candidateBtnArr addObject:buttton];
        }

    }
    return self;
}

#pragma mark - observer
- (void)addObserver{
    FGDiffcultyCandidataAnswerButton *btn = (FGDiffcultyCandidataAnswerButton*)self.candidateBtnArr[2];
    [btn addObserver:self forKeyPath:@"isEnd" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver{
    @try {
        FGDiffcultyCandidataAnswerButton *btn = (FGDiffcultyCandidataAnswerButton*)self.candidateBtnArr[2];
        [btn removeObserver:self forKeyPath:@"isEnd"];
    }@catch (NSException *exception) {
        FGLOG(@"多次删除了");
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    if ([object isKindOfClass:[FGDiffcultyCandidataAnswerButton class]]) {
        BOOL isEnd = [(FGDiffcultyCandidataAnswerButton*)object isEnd];
        if ([keyPath isEqualToString:@"isEnd"] && isEnd ) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(challengeFailure)]){
                [self.delegate challengeFailure];
                [self removeObserver];
            }
        }
    }
}

#pragma mark -
- (void)candidateBtnClick:(UIButton *)sender{
    [self removeObserver];
    
    for (FGDiffcultyCandidataAnswerButton *temp in self.candidateBtnArr) {
        [temp stopWaterRipper];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCandidateActionType:)]){
        [self.delegate didClickCandidateActionType:sender.tag];
    }
}

- (void)pauseWaterRipper{
    for (FGDiffcultyCandidataAnswerButton *view in self.candidateBtnArr) {
        [view pauseWaterRipper];
    }
}

- (void)continueWaterRipper{
    for (FGDiffcultyCandidataAnswerButton *view in self.candidateBtnArr) {
        [view continueWaterRipper];
    }
}


- (void)setupAnswerModel:(FGMathAnswerOptionsModel*)answerOptionModel{
    //监听是否完成倒计时,监听一个，存在误差
    [self addObserver];

    //随机产生正确答案的位置
    NSMutableArray *anwerArr = [NSMutableArray array];
    [anwerArr addObject:answerOptionModel.firstNum];
    [anwerArr addObject:answerOptionModel.secondNum];
    [anwerArr addObject:answerOptionModel.thirdNum];
    [anwerArr insertObject:answerOptionModel.answerNum atIndex:answerOptionModel.answerIndex];
    CGFloat duration = 0.3;
    for (int i = 0; i < anwerArr.count; i ++){
        if (i > 2){
            duration = 0.7;
        }
        [self setButtonView:self.candidateBtnArr[i] title:anwerArr[i] duration:duration];
        if (i == answerOptionModel.answerIndex){
            FGDiffcultyCandidataAnswerButton *anwerBtn = (FGDiffcultyCandidataAnswerButton *)self.candidateBtnArr[i];
            anwerBtn.actionBtn.tag = MathOperationChooseResultTypeCorrect;
        }
    }
    
    CGFloat btnMargin = (kScreenWidth - 4*btnWidth)/5;
    //有5个间隙
    CGFloat x1 = kScreenWidth/2 - btnWidth*3/2 - 2*btnMargin;
    CGFloat x2 = kScreenWidth/2 - btnWidth/2 - btnMargin;
    [self viewAnimation:self.candidateBtnArr[0] duration:0.5 x:-x1 y:0 alpha:1.0];
    [self viewAnimation:self.candidateBtnArr[1] duration:0.5 x:x1 y:0 alpha:1.0];
    [self viewAnimation:self.candidateBtnArr[2] duration:1.0 x:-x2 y:0 alpha:1.0];
    [self viewAnimation:self.candidateBtnArr[3] duration:1.0 x:x2 y:0 alpha:1.0];
    
}

#pragma mark-----CAAnimation
- (void)viewCAAnimation:(UIView *)view duration:(CGFloat )duration keyPath:(NSString *)keyPath toValue:(NSNumber *)number{
    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = number;
    animation.duration = duration;
    [view.layer addAnimation:animation forKey:nil];
}

#pragma mark-----Animation 子菜单动画
- (void)viewAnimation:(UIView *)view duration:(CGFloat )duration x:(CGFloat)x y:(CGFloat)y alpha:(CGFloat)alpha{
    view.center = CGPointMake(self.bgView.frame.size.width/2 + x, self.bgView.frame.size.height/2 + y);
}

#pragma mark--------设置button的属性
//标题  大小 初始位置 响应时间
- (void)setButtonView:(FGDiffcultyCandidataAnswerButton *)buttton title:(NSString *)title duration:(CGFloat)duration{
    buttton.actionBtn.tag = MathOperationChooseResultTypeError;
    buttton.isEnd = NO;
    [buttton startWaterRipper];
    [buttton.actionBtn setTitle:title forState:(UIControlStateNormal)];
}

@end
