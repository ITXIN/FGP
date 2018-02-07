//
//  FGDrawBirdView.m
//  FGProject
//
//  Created by Bert on 2016/12/29.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGDrawBirdView.h"

@implementation FGDrawBirdView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

//- (void)drawBird
//{
//    CGPoint center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetWidth(self.frame)/2);
//    CGFloat lineH = 10;
//    CGFloat smallRadius = 5;
//    CGFloat bigRadius = 10;
//    CGFloat lineW = 5;
//    
//    CGFloat headRadius = 6;
//    CGFloat eyeRadius  = 4;
//    
//    
//    for (int i = 0; i < 4; i ++)
//    {
//        
//        UIBezierPath *circlePath = [UIBezierPath bezierPath];
//        circlePath.lineWidth = 2.0;
//        circlePath.lineCapStyle = kCGLineCapRound;
//        circlePath.lineJoinStyle = kCGLineJoinRound;
//        
//        
//        CAShapeLayer *circleLayer = [CAShapeLayer layer];
//        circleLayer.lineCap = kCALineCapRound;
//        circleLayer.lineJoin =  kCALineJoinRound;
//        // 设置填充颜色
//        circleLayer.fillColor = [UIColor clearColor].CGColor;
//        // 设置线宽
//        circleLayer.lineWidth = 2.0;
//        // 设置线的颜色
//        circleLayer.strokeColor = [UIColor whiteColor].CGColor;
//        circleLayer.strokeEnd = 1;
//        circleLayer.strokeStart = 0.0;
//        
//        if (i == 0)//竖椭圆
//        {
//            //从下半部开始顺时针绘制
//            [circlePath moveToPoint:(CGPoint){center.x+smallRadius,center.y}];
//            
//            
//            [circlePath addArcWithCenter:center radius:smallRadius startAngle:0 endAngle:M_PI clockwise:YES];
//            
//            //左边竖线
//            [circlePath addQuadCurveToPoint:CGPointMake(center.x-smallRadius, center.y-lineH) controlPoint:CGPointMake(center.x-smallRadius, center.y-lineH/2)];
//            
//            //上半圆
//            [circlePath addArcWithCenter:(CGPoint){center.x,center.y- lineH} radius:smallRadius startAngle:M_PI endAngle:2*M_PI clockwise:YES];
//            
//            //右边竖线
//            [circlePath addQuadCurveToPoint:CGPointMake(center.x+smallRadius, center.y) controlPoint:CGPointMake(center.x+smallRadius, center.y-lineH/2)];
//            self.circleLayer = circleLayer;
//            
//        }else if (i == 1)//下右边半圆及竖线横线
//        {
//            [circlePath addArcWithCenter:center radius:bigRadius startAngle:0 endAngle:M_PI/2 clockwise:YES];
//            [circlePath addLineToPoint:CGPointMake(center.x, center.y+bigRadius+lineH/2)];
//            [circlePath addLineToPoint:CGPointMake(center.x+lineW, center.y+bigRadius+lineH/2)];
//            
//            self.circleRightHalfLayer = circleLayer;
//        }else if (i == 2)
//        {
//            //下左边半圆
//            [circlePath addArcWithCenter:center radius:bigRadius startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
//            
//            self.circleLeftHalfLayer = circleLayer;
//        }else if (i == 3)
//        {
//            
//            //左边横线
//            [circlePath moveToPoint:CGPointMake(center.x-lineW, center.y+bigRadius+lineH/2)];
//            [circlePath addLineToPoint:(CGPoint){center.x,center.y+bigRadius+lineH/2}];
//            
//            self.lineLeftLayer = circleLayer;
//            
//        }
//        
//        circleLayer.path = circlePath.CGPath;
//        
//        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//        pathAnima.duration = 0.5f;
//        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
//        pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
//        pathAnima.fillMode = kCAFillModeForwards;
//        pathAnima.removedOnCompletion = YES;
//        [circleLayer addAnimation:pathAnima forKey:@"strokeEndAnimation1"];
//        
//    }
//}

@end
