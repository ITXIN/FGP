//
//  FGRootView.m
//  FGProject
//
//  Created by pingan on 2018/8/7.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGRootView.h"
#import "CARadarView.h"
@implementation FGRootView

- (void)initSubviews{
    [super initSubviews];
    //红色气球
    self.redImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiqiu3.png"]];
    [self.bgView addSubview:self.redImageView];
    
    //黄色气球
    self.yellowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huangqiu.png"]];
    [self.bgView addSubview:self.yellowImageView];
    
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _startBtn.frame = CGRectMake(kScreenWidth - 100 - kScreenHeight/6, kScreenHeight/2, kScreenHeight/6, kScreenHeight/6);
    _startBtn.hidden = YES;
    [_startBtn setTintColor:[UIColor whiteColor]];
    [_startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_startBtn setImage:[UIImage imageNamed:@"qiqiu_start"] forState:UIControlStateNormal];
    _startBtn.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:_startBtn];
    
    //太阳
    _sunImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth+50, kScreenHeight/6, kScreenWidth/10, kScreenWidth/10)];
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
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kScreenHeight, kScreenHeight/3*4) radius:kScreenHeight startAngle:M_PI endAngle:M_PI*2 clockwise:true];
    // 设置贝塞尔曲线路径
    basicAnimX.path = circlePath.CGPath;
    [_sunImgView.layer addAnimation:basicAnimX forKey:@"KCBasicAnimation_RotationX"];
    
    
    //    self.radarView = [[CARadarView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight+100, kScreenHeight+100)];
    //    [self.bgView addSubview:self.radarView];
    //    self.radarView.center = self.center;
    //    self.radarView.fillColor = [UIColor whiteColor];
    //    self.radarView.opacityValue = 0.9;
    //    [self.radarView startAnimation];
    
}

- (void)startBtnClick:(UIButton *)btn{
 
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