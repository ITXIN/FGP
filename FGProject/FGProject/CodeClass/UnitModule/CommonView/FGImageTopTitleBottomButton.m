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
    if (self){
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
    CGFloat offset = 10.0f;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.frame.size.width, -self.imageView.frame.size.height-offset/2, 0);
    // 由于iOS8中titleLabel的size为0，用上面这样设置有问题，修改一下即可
    self.imageEdgeInsets = UIEdgeInsetsMake(-self.titleLabel.intrinsicContentSize.height-offset/2, 0, 0, -self.titleLabel.intrinsicContentSize.width);
}

@end
