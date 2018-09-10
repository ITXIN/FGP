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
    CGFloat btnHeight;
    CGFloat btnMargin;
}

-(void)dealloc{
    [_timer invalidate];
    _timer = nil;
    [self removeObserver];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        btnWidth = kScreenHeight/4;
        btnHeight = kScreenHeight/4;
        btnMargin = (kScreenWidth - 4*btnWidth)/5;
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,btnHeight)];
        [self addSubview:_bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.candidateBtnArr = [NSMutableArray array];
     
        for (int i = 0; i < 4; i ++){
            FGDiffcultyCandidataAnswerButton *buttton =  [[FGDiffcultyCandidataAnswerButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
            buttton.alpha = 1;
            buttton.center = self.bgView.center;
            //tag值默认为0
            buttton.tag = MathOperationChooseResultTypeError;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(candidateBtnClick:)];
            [buttton addGestureRecognizer:tap];
            
            [self.bgView addSubview:buttton];
            [self.candidateBtnArr addObject:buttton];
        }
        
        [self setupTimer];
    }
    return self;
}

- (void)addObserver{
//    @try {
//        [self removeObserver];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"多次删除了");
//    }
    FGDiffcultyCandidataAnswerButton *btn = (FGDiffcultyCandidataAnswerButton*)self.candidateBtnArr[2];
    [btn addObserver:self forKeyPath:@"isEnd" options:NSKeyValueObservingOptionNew context:nil];
        NSLog(@"---add---%@",btn);
}

- (void)removeObserver{
    FGDiffcultyCandidataAnswerButton *btn = (FGDiffcultyCandidataAnswerButton*)self.candidateBtnArr[2];
    [btn removeObserver:self forKeyPath:@"isEnd"];
    NSLog(@"---remov---%@",btn);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
//    if ([object isKindOfClass:[FGDiffcultyCandidataAnswerButton class]]) {
//        BOOL isEnd = [(FGDiffcultyCandidataAnswerButton*)object isEnd];
//        if ([keyPath isEqualToString:@"isEnd"] && isEnd ) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(challengeFailure)]){
//                [self.delegate challengeFailure];
//                [self removeObserver];
//            }
//        }
//    }
}


#pragma mark -
#pragma mark ---init Timer
- (void)setupTimer{
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer timerWithTimeInterval:30.0 target:self selector:@selector(autoAction) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark -
#pragma mark --- timeAction
- (void)autoAction{
//    [AnimationProcess springAnimationProcessWithView:self.candidateBtnArr[arc4random() %self.candidateBtnArr.count] upHeight:arc4random()%(40-20+1)+20];
//    [AnimationProcess scaleAnmiationProcessWithView:self.candidateBtnArr[arc4random() %self.candidateBtnArr.count]];
}

- (void)candidateBtnClick:(UITapGestureRecognizer *)sender{
    
    [self removeObserver];
    
    for (FGDiffcultyCandidataAnswerButton *temp in self.candidateBtnArr) {
        [temp stopWaterRipper];
    }
    
    FGDiffcultyCandidataAnswerButton *btn = (FGDiffcultyCandidataAnswerButton*)sender.view;
    //最好的方法是比较点击间隔时间如果间隔时间大于某个值就
    if (btn.tag == MathOperationChooseResultTypeCorrect) {
//        [AnimationProcess springAnimationProcessWithView:btn upHeight:30.0];
    }else{
//        [AnimationProcess scaleAnmiationProcessWithView:btn];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCandidateActionType:)]){
        [self.delegate didClickCandidateActionType:btn.tag];
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
//        [AnimationProcess springAnimationProcessWithView:self.candidateBtnArr[i] upHeight:arc4random()%(100-30+1)+30];
        if (i == answerOptionModel.answerIndex){
            UIButton *anwerBtn = (UIButton *)self.candidateBtnArr[i];
            anwerBtn.tag = MathOperationChooseResultTypeCorrect;
        }
    }
    
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
    
//    [UIView animateWithDuration:duration animations:^{
//        [self viewCAAnimation:view duration:duration keyPath:@"transform.rotation.z" toValue:[NSNumber numberWithFloat:(-M_PI/180 *360)]];
        view.center = CGPointMake(self.bgView.frame.size.width/2 + x, self.bgView.frame.size.height/2 + y);
//        view.alpha = alpha;
//    } completion:nil];
}

#pragma mark--------设置button的属性
//标题  大小 初始位置 响应时间
- (void)setButtonView:(FGDiffcultyCandidataAnswerButton *)buttton title:(NSString *)title duration:(CGFloat)duration{
    buttton.tag = MathOperationChooseResultTypeError;
    buttton.isEnd = NO;
    [buttton waterWaveAnimation];
    [buttton setTitle:title forState:(UIControlStateNormal)];
//    [UIView animateWithDuration:duration animations:^{
//        buttton.center = CGPointMake(self.bgView.frame.size.width/2, self.bgView.frame.size.height/2);
//    } completion:nil];
}


@end
