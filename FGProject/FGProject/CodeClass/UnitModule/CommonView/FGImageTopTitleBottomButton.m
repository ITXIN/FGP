//
//  FGImageTopTitleBottomButton.m
//  FGProject
//
//  Created by 鑫龙魂 on 2018/4/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGImageTopTitleBottomButton.h"

@implementation FGImageTopTitleBottomButton

- (instancetype)init{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//使图片和文字居中显示
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint imageCenter = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2 - CGRectGetHeight(self.imageView.frame)/2-5.0);
    self.imageView.center = imageCenter;
    
    CGPoint titleCenter = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2+10.0);
    self.titleLabel.center = titleCenter;
    
}

@end
