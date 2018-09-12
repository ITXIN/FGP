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
    
    self.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effView = [[UIVisualEffectView alloc]initWithEffect:self.blurEffect];
    [self addSubview: self.effView];
}

- (void)setupSubviewsLayout{
    [super setupSubviewsLayout];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.effView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setBlurEffect:(UIBlurEffect *)blurEffect{
    _blurEffect = blurEffect;
}

@end
