//
//  FGNavigationView.m
//  FGProject
//
//  Created by Bert on 2017/2/8.
//  Copyright © 2017年 XL. All rights reserved.
//

#import "FGNavigationView.h"

@implementation FGNavigationView

-(instancetype)initWithDelegate:(id)delegate{
    self = [super init];
    if (self){
        self.delegate = delegate;
        self.navigationView = ({
            UIView *view = [[UIView alloc]init];
            [self addSubview:view];
            view.backgroundColor = RGBA(142, 221, 200,0.5);
            view;
        });
        
        self.backBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:btn];
            [btn setImage:[UIImage imageNamed:@"backToRootVC"] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        self.titleLab = ({
            UILabel *label = [[UILabel alloc]init];
            [self addSubview:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            
            label;
        });
        
    }
    return self;
}

- (void)backAction:(UIButton*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(popToRootViewController)]) {
        [self.delegate popToRootViewController];
        
    }else{
        UIViewController *preView =(UIViewController*) self.delegate;
        [preView.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}

-(void)layoutSubviews{
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kiPhoneX) {
            make.left.mas_equalTo(30);
        }else{
            make.left.mas_equalTo(30);
        }
        make.centerY.equalTo(self.navigationView);
    }];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}

@end
