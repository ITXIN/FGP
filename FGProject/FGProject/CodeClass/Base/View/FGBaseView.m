//
//  FGBaseView.m
//  FGProject
//
//  Created by avazuholding on 2018/3/20.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGBaseView.h"

@implementation FGBaseView
//不要在实现init了，initWithFrame会调用super init
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initSubviews];
        [self setupSubviewsLayout];
    }
    return self;
}
- (void)initSubviews{
    self.bgView = ({
        UIView *view = [[UIView alloc]init];
        [self addSubview:view];
        
        view;
    });
    
}
- (void)setupSubviewsLayout{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
