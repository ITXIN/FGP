//
//  FGFadeStringView.m
//  FGProject
//
//  Created by Bert on 2016/11/9.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGFadeStringView.h"

@interface FGFadeStringView ()

@property (nonatomic,strong) UILabel *backLabel;
@property (nonatomic,strong) UILabel *frontLabel;

@end

@implementation FGFadeStringView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    
        self.backLabel= ({
            UILabel *label = [[UILabel alloc]init];
            [self addSubview:label];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
//            label.textColor = <#color#>;
//            label.font = [UIFont systemFontOfSize:<#fontSize#>];
            
            label;
        });
        
        self.frontLabel= ({
            UILabel *label = [[UILabel alloc]init];
            [self addSubview:label];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            //            label.textColor = <#color#>;
            //            label.font = [UIFont systemFontOfSize:<#fontSize#>];
            
            label;
        });
        
        
//        _frontLabel = [[UILabel alloc]initWithFrame:self.bounds];
//        [self addSubview:_frontLabel];
        [self createMask];
//        self.foreColor = [UIColor whiteColor];
//        self.backColor = [UIColor redColor];
//        self.font = [UIFont systemFontOfSize:20];
//        _alignment = NSTextAlignmentCenter;
//        [self fadeRightWithDuration:4];
        
        [_backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [_frontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
    }
    return self;
}


- (void)createMask
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, 200, 30);
    layer.colors = @[(id)[UIColor clearColor],(id)[UIColor redColor].CGColor,(id)[UIColor blackColor].CGColor,(id)[UIColor clearColor].CGColor];
    layer.locations = @[@(0.01),@(0.1),@(0.9),@(0.99)];
    //    layer.startPoint = CGPointMake(0, 0);
    //    layer.endPoint = CGPointMake(1, 0);
    _frontLabel.layer.mask = layer;
    
}

- (void)fadeRightWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.translation.x";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(200);
    basicAnimation.duration = duration;
    basicAnimation.repeatCount = LONG_MAX;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_frontLabel.layer.mask addAnimation:basicAnimation forKey:nil];
}

- (void)iPhoneFadeWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.translation.x";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(200+200/2.0);
    basicAnimation.duration = duration;
    basicAnimation.repeatCount = LONG_MAX;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_frontLabel.layer.mask addAnimation:basicAnimation forKey:nil];
    
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    group.animations = @[basicAnimation,_frontLabel.layer.animationKeys];
    
    
}

- (void)setBackColor:(UIColor *)backColor
{
    _backColor = backColor;
    _backLabel.textColor = backColor;
    
}

- (void)setForeColor:(UIColor *)foreColor
{
    _foreColor = foreColor;
    _frontLabel.textColor = foreColor;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _backLabel.font = font;
    _frontLabel.font = font;
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    _alignment = alignment;
    _backLabel.textAlignment = alignment;
    _frontLabel.textAlignment = alignment;
}

- (void)setTextStr:(NSString *)textStr
{
    _textStr = textStr;
    _backLabel.text = textStr;
    _frontLabel.text = textStr;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.frontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

@end
