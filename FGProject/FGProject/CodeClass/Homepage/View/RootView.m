//
//  RootView.m
//  FGProject
//
//  Created by XL on 15/7/8.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "RootView.h"
@interface RootView()
{
    FGBlurEffectView *blurEffectView;
}
@property (nonatomic,strong) UIView *bgView;

@end

@implementation RootView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bgView = [[UIView alloc]init];
        [self addSubview:self.bgView];
       
        blurEffectView = [[FGBlurEffectView alloc]init];
        [self.bgView addSubview:blurEffectView];
        blurEffectView.effView.alpha = 0.5;
        UIImageView *bgImgView = blurEffectView.bgImageView;
        
        //红色气球
        self.redImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiqiu3.png"]];
        [bgImgView addSubview:self.redImageView];
        
        //黄色气球
        self.yellowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huangqiu.png"]];
        [bgImgView addSubview:self.yellowImageView];
        

        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(ScreenWidth - 100 - ScreenHeight/6, ScreenHeight/2, ScreenHeight/6, ScreenHeight/6);
        _startBtn.hidden = YES;
        [_startBtn setTintColor:[UIColor whiteColor]];
        [_startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setImage:[UIImage imageNamed:@"qiqiu_start"] forState:UIControlStateNormal];
        _startBtn.backgroundColor = [UIColor clearColor];
        [bgImgView addSubview:_startBtn];
        
//        _startBtn.hidden = YES;
        //太阳
        _sunImgView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth+50, ScreenHeight/6, ScreenWidth/6, ScreenWidth/6)];
        _sunImgView.image = [UIImage imageNamed:@"taiyang-03"];
        [bgImgView addSubview:_sunImgView];
        
        //晃动动画
        CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/7];
        basicAnim.duration = 2.0;
        basicAnim.autoreverses = YES;
        basicAnim.repeatCount = HUGE_VAL;
        basicAnim.removedOnCompletion = NO;
        
        [_startBtn.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
        [self.redImageView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
        [self.yellowImageView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
        basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/9];
        [_sunImgView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
        
        //太阳移动
        CABasicAnimation *basicAnimX = [CABasicAnimation animationWithKeyPath:@"position"];
        basicAnimX.fromValue = [NSValue valueWithCGPoint:CGPointMake(-50, ScreenHeight/5*2)];
        basicAnimX.toValue = [NSValue valueWithCGPoint:_sunImgView.layer.position];
        basicAnimX.duration = 13.0;
        basicAnimX.autoreverses = NO;
        basicAnimX.repeatCount = HUGE_VAL;
        basicAnimX.removedOnCompletion = NO;
        
        [_sunImgView.layer addAnimation:basicAnimX forKey:@"KCBasicAnimation_RotationX"];
        
    
       
    }
    return self;
}


- (void)startBtnClick:(UIButton *)btn
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(startBtnAction)])
//    {
//        [self.delegate startBtnAction];
//    }
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (AVAILABLE_IOS_11) {
//            make.top.equalTo(self.mas_safeAreaLayoutGuideTop);
//            make.left.equalTo(self.mas_safeAreaLayoutGuideLeft);
//            make.right.equalTo(self.mas_safeAreaLayoutGuideRight);
//            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
//        }else{
            make.edges.equalTo(self);
//        }
    }];
    [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
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
