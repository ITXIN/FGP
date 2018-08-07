//
//  FGImageLeftTitleRightButtom.m
//  FGProject
//
//  Created by pingan on 2018/6/18.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGImageLeftTitleRightButtom.h"

@implementation FGImageLeftTitleRightButtom

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
    CGFloat offset = 15.0f;
    self.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, offset,0, 0);
}

@end
