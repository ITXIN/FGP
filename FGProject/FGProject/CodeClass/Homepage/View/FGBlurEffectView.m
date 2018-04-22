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
        UIImageView *imgView = [[UIImageView alloc]init];//
        [self.bgView addSubview:imgView];
        //            imgView.image = [FGProjectHelper blurryImage:[UIImage imageNamed:[NSString stringWithFormat:@"Indexbg-0%d",arc4random()%(3-1+1)+1]] withBlurLevel:1];
        imgView.image = [FGProjectHelper blurryImage:[UIImage imageNamed:@"Indexbg-01"] withBlurLevel:1];//返回按钮颜色
        
        imgView;
        
    });
    self.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effView = [[UIVisualEffectView alloc]initWithEffect:self.blurEffect];
    [self.bgView addSubview: self.effView];
    
    
}
- (void)setupSubviewsLayout{
    [super setupSubviewsLayout];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [self.effView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
}

- (void)setBlurEffect:(UIBlurEffect *)blurEffect
{
    _blurEffect = blurEffect;
}

@end
