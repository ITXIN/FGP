//
//  TooltipForAnswerView.m
//  FGProject
//
//  Created by XL on 15/7/3.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "TooltipForAnswerView.h"

@implementation TooltipForAnswerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        self.userInteractionEnabled = YES;
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/3, kScreenHeight/3, kScreenWidth/3, kScreenHeight/3)];
        _bgView.userInteractionEnabled = YES;
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
        
        UIImageView *bgimgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)];
        
        bgimgView.image = [UIImage imageNamed:@"tankuang_bg02.png"];
        [_bgView addSubview:bgimgView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, _bgView.frame.size.width-10, _bgView.frame.size.height/3-10)];
        
        titleLabel.text = @"真棒!送你一颗星星";
        titleLabel.textColor = [UIColor redColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_bgView addSubview:titleLabel];
        
        _imgView = [[UIImageView alloc]init];
        _imgView.frame = CGRectMake(_bgView.frame.size.width/3, _bgView.frame.size.height/3, 40,40);
        _imgView.backgroundColor = [UIColor clearColor];
        _imgView.image = [UIImage imageNamed:@"start-02.png"];
        _imgView.userInteractionEnabled = YES;
        [_bgView addSubview:_imgView];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(_bgView.frame.size.width/3/4, _bgView.frame.size.height/3*2+5, _bgView.frame.size.width/3, _bgView.frame.size.height/3-10);
        
        _backBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_backBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.tag = REST_BTN_TAG_TOOLTIP;
        [_backBtn setTitle:@"休息一下" forState: UIControlStateNormal];
        [_bgView addSubview:_backBtn];
        
        _cotinueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cotinueBtn.frame = CGRectMake(_bgView.frame.size.width/3*2-_bgView.frame.size.width/3/4, _bgView.frame.size.height/3*2+5, _bgView.frame.size.width/3, _bgView.frame.size.height/3-10);
        _cotinueBtn.tag = CONTINUE_BTN_TAG_TOOLTIP;
        _cotinueBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_cotinueBtn setTitle:@"继续" forState: UIControlStateNormal];
        [_cotinueBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_cotinueBtn];
        
        self.alpha = 0.0;
        [UIView animateWithDuration:1.0 animations:^{
            self.alpha = 1.0;
        }];
    }
    return self;
}

- (void)buttonAction:(UIButton *)btn{
    self.actionIndexBlock(btn.tag);
}

@end
