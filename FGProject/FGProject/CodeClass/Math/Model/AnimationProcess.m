//
//  AnimationProcess.m
//  FGProject
//
//  Created by Bert on 16/1/11.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "AnimationProcess.h"

@implementation AnimationProcess

+ (void)springAnimationProcessWithView:(UIView *)view upHeight:(CGFloat)upHeight{
    CGPoint center = view.center;
    center.y -= upHeight;
    view.center = center;
    [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.2f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGPoint center = view.center;
        center.y += upHeight;
        view.center = center;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)scaleAnmiationProcessWithView:(UIView *)view{
    view.transform = CGAffineTransformMakeScale(0.2, 0.2);
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [AnimationProcess springAnimationProcessWithView:view upHeight:30.f];
        }];
    }];
}

@end
