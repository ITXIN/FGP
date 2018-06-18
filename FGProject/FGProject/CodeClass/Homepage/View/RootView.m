//
//  RootView.m
//  FGProject
//
//  Created by XL on 15/7/8.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "RootView.h"
#import "CARadarView.h"
@interface RootView()

@end

@implementation RootView

- (void)initSubviews{
    [super initSubviews];
    
    //红色气球
    self.redImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiqiu3.png"]];
    [self.bgView addSubview:self.redImageView];
    
    //黄色气球
    self.yellowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huangqiu.png"]];
    [self.bgView addSubview:self.yellowImageView];
    
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame = CGRectMake(ScreenWidth - 100 - ScreenHeight/6, ScreenHeight/2, ScreenHeight/6, ScreenHeight/6);
    _startBtn.hidden = YES;
    [_startBtn setTintColor:[UIColor whiteColor]];
    [_startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_startBtn setImage:[UIImage imageNamed:@"qiqiu_start"] forState:UIControlStateNormal];
    _startBtn.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:_startBtn];
    
    //太阳
    _sunImgView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth+50, ScreenHeight/6, ScreenWidth/10, ScreenWidth/10)];
    _sunImgView.image = [UIImage imageNamed:@"taiyang-03"];
    [self.bgView addSubview:_sunImgView];
    
   //晃动动画
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/7];
    basicAnim.duration = 2.0;
    basicAnim.autoreverses = YES;
    basicAnim.repeatCount = HUGE_VAL;
    basicAnim.removedOnCompletion = NO;
    basicAnim.fillMode = kCAFillModeForwards;
    [_startBtn.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
    [self.redImageView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
    [self.yellowImageView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/9];
    [_sunImgView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
    
   //太阳移动
    CAKeyframeAnimation *basicAnimX = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    basicAnimX.duration = 50.0;
    basicAnimX.autoreverses = NO;
    basicAnimX.repeatCount = HUGE_VAL;
    basicAnimX.removedOnCompletion = NO;
    //以原点和半径
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(ScreenHeight, ScreenHeight/3*4) radius:ScreenHeight startAngle:M_PI endAngle:M_PI*2 clockwise:true];
    // 设置贝塞尔曲线路径
    basicAnimX.path = circlePath.CGPath;
    [_sunImgView.layer addAnimation:basicAnimX forKey:@"KCBasicAnimation_RotationX"];
    
    
//    self.radarView = [[CARadarView alloc]initWithFrame:CGRectMake(0, 0, ScreenHeight+100, ScreenHeight+100)];
//    [self.bgView addSubview:self.radarView];
//    self.radarView.center = self.center;
//    self.radarView.fillColor = [UIColor whiteColor];
//    self.radarView.opacityValue = 0.9;
//    [self.radarView startAnimation];
    
}



- (void)startBtnClick:(UIButton *)btn
{
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(startBtnAction)])
    //    {
    //        [self.delegate startBtnAction];
    //    }
    
}

- (void)setupSubviewsLayout{
    [super setupSubviewsLayout];
    
    [self.redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo(CGSizeMake(60, 130));
    }];
    [self.yellowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.redImageView);
        make.right.mas_equalTo(-100);
        make.size.equalTo(self.redImageView);
    }];
}

@end
