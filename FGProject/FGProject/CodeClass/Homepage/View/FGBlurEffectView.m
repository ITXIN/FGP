//
//  FGBlurEffectView.m
//  FGProject
//
//  Created by Bert on 2016/12/27.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGBlurEffectView.h"

@implementation FGBlurEffectView

- (void)initSubviews{
    [super initSubviews];
    //大的背景图片
    self.bgImageView =  ({
        UIImageView *imgView = [[UIImageView alloc]init];
        [self addSubview:imgView];
        imgView.image = [UIImage imageNamed:@"Indexbg-01"];
        imgView;
    });
    
    
    //晃动动画
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2];
    basicAnim.duration = 2.0;
    basicAnim.autoreverses = YES;
    basicAnim.repeatCount = HUGE_VAL;
    basicAnim.removedOnCompletion = NO;
    basicAnim.fillMode = kCAFillModeForwards;
    
    //红色气球
    self.redImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiqiu3.png"]];
    [self addSubview:self.redImageView];
    //黄色气球
    self.yellowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huangqiu.png"]];
    [self addSubview:self.yellowImageView];
    [self.redImageView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
    [self.yellowImageView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];

    self.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effView = [[UIVisualEffectView alloc]initWithEffect:self.blurEffect];
    [self addSubview: self.effView];
}

- (void)setupSubviewsLayout{
    [super setupSubviewsLayout];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
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
    
    [self.effView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setBlurEffect:(UIBlurEffect *)blurEffect{
    _blurEffect = blurEffect;
}

@end
