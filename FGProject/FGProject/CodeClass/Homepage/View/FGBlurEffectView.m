//
//  FGBlurEffectView.m
//  FGProject
//
//  Created by Bert on 2016/12/27.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGBlurEffectView.h"

@interface FGBlurEffectView ()<NSCopying>

@end

@implementation FGBlurEffectView

- (void)initSubviews{
    [super initSubviews];
    
    //大的背景图片
    self.bgImageView =  ({
        UIImageView *imgView = [[UIImageView alloc]init];
        [self addSubview:imgView];
        imgView.image = [UIImage imageNamed:@"Indexbg-01"];
        imgView.alpha = 0.8;
        imgView;
    });
    //晃动动画
    //         CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //         basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2];
    //         basicAnim.duration = 1.5;
    //         basicAnim.autoreverses = YES;
    //         basicAnim.repeatCount = HUGE_VAL;
    //         basicAnim.removedOnCompletion = NO;
    //         basicAnim.fillMode = kCAFillModeForwards;
    //
    //    CATransition * ani = [CATransition animation];
    //       ani.type = kCATransitionFade;
    //       ani.subtype = kCATransitionFromLeft;
    //       ani.duration = 1.5;
    //        ani.repeatCount = HUGE_VAL;
    //红色气球
    //         self.redImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qiqiu3.png"]];
    //         self.redImageView.frame = CGRectMake(100, 100, 60, 130);
    //         [self addSubview:self.redImageView];
    //   [self.redImageView.layer addAnimation:ani forKey:@"transitionAni"];
    
    //黄色气球
    //    self.yellowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"huangqiu.png"]];
    //    [self addSubview:self.yellowImageView];
    
    //    [self.redImageView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
    //    [self.yellowImageView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
    //
    //http://cache.baiducontent.com/c?m=9d78d513d9981cee4fede52e5e478e364407c0356ac3975521dbc90ed5264c40347bfefe62670704a49421365cfc1806b1ac6565377471eac4d5d3179ca6922a2c8f2434701d9b4214d618a4dc46529b66cf04&p=8777830685cc43b108e2977e075d94&newp=9379c64ad4934eac58e7c1385b5e9e231610db2151d7d2146b82c825d7331b001c3bbfb42327160ed2c4766002a9435debf534723d0923a3dda5c91d9fb4c57479&user=baidu&fm=sc&query=iOS+backboardd&qid=a96da0400053f7d9&p1=4
    //UIVisualEffectView 和 动画一起使用会导致backboardd 占用cpu高
        self.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effView = [[UIVisualEffectView alloc]initWithEffect:self.blurEffect];
        [self addSubview: self.effView];
    
    
    //    [self layoutIfNeeded];
    //    POPBasicAnimation * butAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    //    butAnimation.duration = 2.0f;
    //    butAnimation.repeatCount = HUGE_VAL;
    //    butAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(kScreenWidth/2, kScreenHeight/2)];
    //    [self.redImageView pop_addAnimation:butAnimation forKey:@"btn_Animation"];
    //    [self.yellowImageView pop_addAnimation:butAnimation forKey:@"btn_Animation"];
    
}

- (void)setupSubviewsLayout{
    [super setupSubviewsLayout];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //    [self.redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(100);
    //        make.top.mas_equalTo(100);
    //        make.size.mas_equalTo(CGSizeMake(60, 130));
    //    }];
    //
    //    [self.yellowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.redImageView);
    //        make.right.mas_equalTo(-100);
    //        make.size.equalTo(self.redImageView);
    //    }];
    
    [self.effView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setBlurEffect:(UIBlurEffect *)blurEffect{
    _blurEffect = blurEffect;
}

@end
