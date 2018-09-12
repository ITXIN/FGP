//
//  DiffcultyLevelView.m
//  FGProject
//
//  Created by Bert on 16/1/8.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "DiffcultyLevelView.h"
@interface DiffcultyLevelView ()

@end
@implementation DiffcultyLevelView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.menuBtnArr = [NSMutableArray array];
        self.menuBtnCenterArr = [NSMutableArray array];
        //难易程度
        NSArray *titleArr = @[@"简单",@"中等",@"挑战"];
        CGFloat widthBtn = frame.size.height;
        CGFloat paceBtn = 20.0;
        NSArray *tagArr = @[@(MathOperationActionTypeCompreOfSimple),@(MathOperationActionTypeCompreOfMedium),@(MathOperationActionTypeCompreOfChallenge)];
        for (int i = 0; i < 3; i ++){
            self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesAcion:)];
            
            UIButton *levelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [levelBtn setBackgroundImage:[UIImage imageNamed:@"countNum-bg"] forState:UIControlStateNormal];
            [levelBtn addTarget:self action:@selector(levelAction:) forControlEvents:UIControlEventTouchUpInside];
            [levelBtn setFrame:CGRectMake(self.centerPoint.x, self.centerPoint.y, widthBtn, widthBtn)];
            CGFloat centerX = i*(widthBtn + paceBtn) + widthBtn/2.0;
            [self.menuBtnCenterArr addObject:[NSNumber numberWithFloat:centerX]];
            levelBtn.backgroundColor = [UIColor clearColor];
            levelBtn.tag = [tagArr[i] integerValue];
            [levelBtn setTitle:titleArr[i] forState:UIControlStateNormal];
            [levelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [levelBtn.titleLabel setTextAlignment:NSTextAlignmentCenter];
            [levelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
            [self addSubview:levelBtn];
            
            [levelBtn addGestureRecognizer:self.panGestureRecognizer];
            
            [self.menuBtnArr addObject:levelBtn];
        }
        
        [self showMenu];
    }
    return self;
}

- (void)levelAction:(UIButton *)btn{
    [[SoundsProcess shareInstance]playSoundOfTock];
    [AnimationProcess springAnimationProcessWithView:btn upHeight:30.f];
    if (self.delegate && [self.delegate respondsToSelector:@selector(diffcultyBtnAction:)]){
        [self.delegate diffcultyBtnAction:btn.tag];
    }
}

#pragma mark -
#pragma mark --- panded fucntion
- (void)panGesAcion:(UIPanGestureRecognizer *)sender{
    UIButton *btn = (UIButton *)sender.view;
    [AnimationProcess springAnimationProcessWithView:btn upHeight:30.f];
}

#pragma mark------显示菜单栏
- (void)showMenu{
    CGFloat preCenterX = self.centerPoint.x;
    CGFloat centerY = self.center.y;
    for (int i = 0; i < self.menuBtnArr.count; i ++){
        CGFloat centerX = [self.menuBtnCenterArr[i] floatValue];
        if (preCenterX > centerX){
            centerX = preCenterX - centerX;
        }else{
            centerX = centerX - preCenterX;
        }
        UIButton *btn = (UIButton *)self.menuBtnArr[i];
        [self viewAnimation:btn duration:0.2*i+ 0.2 x:centerX y:centerY alpha:1.0];
        btn.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [UIView animateWithDuration:0.2*i+ 0.2 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1*i+ 0.1 animations:^{
                btn.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [AnimationProcess springAnimationProcessWithView:btn upHeight:30.f];
            }];
        }];
    }
}

#pragma mark-----Animation 子菜单动画
- (void)viewAnimation:(UIView *)view duration:(CGFloat )duration x:(CGFloat)x y:(CGFloat)y alpha:(CGFloat)alpha{
    [UIView animateWithDuration:duration animations:^{
        view.center = CGPointMake(self.centerPoint.x + x, y);
        view.alpha = alpha;
    } completion:nil];
}

@end
