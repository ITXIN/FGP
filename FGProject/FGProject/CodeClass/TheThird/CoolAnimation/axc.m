
//
//  axc.m
//  donghuaText
//
//  Created by Axc_5324 on 16/6/28.
//  Copyright © 2016年 赵新. All rights reserved.
//

#import "axc.h"
//#import "AxcKit.h"
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight  [UIScreen mainScreen].bounds.size.height
@interface axc ()
{
    UIColor *lineColor;
    UIColor *tishikuang;
    int angle;
    UIImageView *imageView;

}
@end

@implementation axc

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
//        lineColor = [UIColor AxcConcreteColor];
//        tishikuang = [UIColor AxcEmeraldColor];
        
        lineColor = [UIColor redColor];
        tishikuang = [UIColor whiteColor];
        
       
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}


- (void)star{
    
    [self TheFirstAnimation];
    [self TheSecondAnimation];
    [self performSelector:@selector(TheThirdAnimation) withObject:nil afterDelay:2.5f];
}

- (void)TheNinthAnimation2{
    UIBezierPath *_path;
    
    
    _path=[UIBezierPath bezierPath];
    
    [_path addArcWithCenter:CGPointMake(70, 500) radius:50 startAngle:0 endAngle: M_PI * 2 clockwise:NO];
    
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=lineColor.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 0.6;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];
}

- (void)TheNinthAnimation{
    UIBezierPath *_path;
    
    //贝塞尔曲线,以下是4个角的位置，相对于_testView1
    CGPoint point1= CGPointMake(ScreenWidth / 2, ScreenHeight / 2 );
    CGPoint point2= CGPointMake(70,500);

    _path=[UIBezierPath bezierPath];
    [_path moveToPoint:point1];//移动到某个点，也就是起始点
    [_path addLineToPoint:point2];

    
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=lineColor.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 0.7;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];

    [self performSelector:@selector(TheNinthAnimation2) withObject:nil afterDelay:0.6];

}

- (void)TheEighthAnimation3{
    
    [self performSelector:@selector(TheNinthAnimation) withObject:nil afterDelay:0.3];

    UIBezierPath *_path;
    
    //贝塞尔曲线,以下是4个角的位置，相对于_testView1
//    CGPoint point1= CGPointMake(350,225);
//    CGPoint point2= CGPointMake(270,225);
//    CGPoint point3= CGPointMake(270,500);
//    CGPoint point4= CGPointMake(70,500);
    CGPoint point1= CGPointMake(50,25);
    CGPoint point2= CGPointMake(70,25);
    CGPoint point3= CGPointMake(70,50);
    CGPoint point4= CGPointMake(10,50);
    
    _path=[UIBezierPath bezierPath];
    [_path moveToPoint:point1];//移动到某个点，也就是起始点
    [_path addLineToPoint:point2];
    [_path addLineToPoint:point3];
    [_path addLineToPoint:point4];
    
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=tishikuang.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 1;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];
    
    [self performSelector:@selector(imageViewAngle) withObject:nil afterDelay:0.9];

}

- (void)imageViewAngle{
    
    UIBezierPath *_path;

    
    _path=[UIBezierPath bezierPath];

//    [_path addArcWithCenter:CGPointMake(70, 500) radius:40 startAngle:0 endAngle: M_PI * 2 clockwise:YES];
[_path addArcWithCenter:CGPointMake(100, 150) radius:40 startAngle:0 endAngle: M_PI * 2 clockwise:YES];
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=tishikuang.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 0.6;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];
    
}


- (void)TheEighthAnimation2{
    
    UIBezierPath *_path;
    
    //贝塞尔曲线,以下是4个角的位置，相对于_testView1
    CGPoint point1= CGPointMake(275,270);
    CGPoint point2= CGPointMake(275,230);
    CGPoint point3= CGPointMake(350,230);
//    CGPoint point4= CGPointMake(350,230);
    
    
    _path=[UIBezierPath bezierPath];
    [_path moveToPoint:point1];//移动到某个点，也就是起始点
    [_path addLineToPoint:point2];
    [_path addLineToPoint:point3];
//    [_path addLineToPoint:point4];
    
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=tishikuang.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 0.6;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];
    
    [self performSelector:@selector(TheEighthAnimation3) withObject:nil afterDelay:0.55];
}


- (void)TheEighthAnimation{
    
    UIBezierPath *_path;
    
    //贝塞尔曲线,以下是4个角的位置，相对于_testView1
    CGPoint point1= CGPointMake(ScreenWidth / 2, ScreenHeight / 2 );
    CGPoint point2= CGPointMake(270,270);
    CGPoint point3= CGPointMake(350,270);
    CGPoint point4= CGPointMake(350,225);

    
    _path=[UIBezierPath bezierPath];
    [_path moveToPoint:point1];//移动到某个点，也就是起始点
    [_path addLineToPoint:point2];
    [_path addLineToPoint:point3];
    [_path addLineToPoint:point4];

    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=tishikuang.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 0.6;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];
    
    
}

- (void)TheSeventhAnimation{
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth / 2 - 80, ScreenHeight / 2 - 80, 160, 160)];
    imageView.alpha = 0;
    imageView.image = [UIImage imageNamed:@"huishou_zhuan@2x.png"];
    imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:imageView];
    [UIView animateWithDuration:0.5 animations:^{
        imageView.alpha = 1;
    }];
    [self startAnimation];
    [self performSelector:@selector(TheEighthAnimation) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(TheEighthAnimation2) withObject:nil afterDelay:0.35];

}
-(void) startAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.01];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
    imageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
    [UIView commitAnimations];
}
-(void)endAnimation{
    angle += 3;
    [self startAnimation];
}

- (void)TheSixthAnimation{
    
    UIView *View = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth / 2, ScreenHeight / 2 , 1, 1)];
    View.layer.borderColor= lineColor.CGColor;
    View.layer.borderWidth= 1.0f;
    View.backgroundColor = [UIColor clearColor];
    View.layer.cornerRadius = 75;
    View.layer.masksToBounds = YES;
    [self addSubview:View];
    
    [UIView animateWithDuration:0.3 animations:^{
        View.frame = CGRectMake(ScreenWidth / 2 - 75, ScreenHeight / 2 - 75, 150, 150);
    }];
    [self performSelector:@selector(TheSeventhAnimation) withObject:nil afterDelay:0.2];
}


- (void)TheFifthAnimation{
    UIBezierPath *_path;
    
    //贝塞尔曲线,以下是4个角的位置，相对于_testView1
    CGPoint point1= CGPointMake(15, ScreenHeight / 2);
    CGPoint point2= CGPointMake(ScreenWidth / 2, ScreenHeight / 2 );
    
    
    _path=[UIBezierPath bezierPath];
    [_path moveToPoint:point1];//移动到某个点，也就是起始点
    [_path addLineToPoint:point2];
    
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=lineColor.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 0.3;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];
    
    [self performSelector:@selector(TheSixthAnimation) withObject:nil afterDelay:0.2];
    
    
}



- (void)TheFourthAnimation{
    
    for (int i = 1; i <= 10; i ++) {
        
        UIBezierPath *_path;
        CGFloat x = 10 + i * ((ScreenWidth - 55) / 10);
        CGPoint point1= CGPointMake(x, 55);
        CGPoint point2= CGPointMake(x, ScreenHeight - 15);
        
        
        _path=[UIBezierPath bezierPath];
        [_path moveToPoint:point1];//移动到某个点，也就是起始点
        [_path addLineToPoint:point2];
        
        CAShapeLayer *shapeLayer=[CAShapeLayer layer];
        shapeLayer.path=_path.CGPath;
        shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
        shapeLayer.strokeColor=lineColor.CGColor;//边框颜色
        [self.layer addSublayer:shapeLayer];
        
        //动画
        CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        // 时间
        
        pathAniamtion.duration = i * 0.3;
        pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
        pathAniamtion.autoreverses = NO;
        [shapeLayer addAnimation:pathAniamtion forKey:nil];
        
    }
    [self performSelector:@selector(TheFifthAnimation) withObject:nil afterDelay:0.5];
    
}



- (void)TheThirdAnimation{
    UIBezierPath *_path;
    
    //贝塞尔曲线,以下是4个角的位置，相对于_testView1
    CGPoint point1= CGPointMake(15, 25);
    CGPoint point2= CGPointMake(45, 55);
    CGPoint point3= CGPointMake(ScreenWidth - 15 - 30, 55);
    CGPoint point4= CGPointMake(ScreenWidth - 15, 25);
    
    _path=[UIBezierPath bezierPath];
    [_path moveToPoint:point1];//移动到某个点，也就是起始点
    [_path addLineToPoint:point2];
    [_path addLineToPoint:point3];
    [_path addLineToPoint:point4];
    
    //controlPoint控制点，不等于曲线顶点
    //    [_path addQuadCurveToPoint:point1 controlPoint:CGPointMake(150, -30)];
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=lineColor.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 1;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];
    
    [self performSelector:@selector(TheFourthAnimation) withObject:nil afterDelay:0.5];
}


- (void)TheSecondAnimation{
    UIBezierPath *_path;
    
    //贝塞尔曲线,以下是4个角的位置，相对于_testView1
    CGPoint point1= CGPointMake(15, 25);
    CGPoint point2= CGPointMake(ScreenWidth - 15, 25);
    CGPoint point3= CGPointMake(ScreenWidth - 15, ScreenHeight - 15);
    CGPoint point4= CGPointMake(15, ScreenHeight - 15);
    
    _path=[UIBezierPath bezierPath];
    [_path moveToPoint:point4];//移动到某个点，也就是起始点
    [_path addLineToPoint:point3];
    [_path addLineToPoint:point2];
    [_path addLineToPoint:point1];
    [_path addLineToPoint:point4];
    
    //controlPoint控制点，不等于曲线顶点
    //    [_path addQuadCurveToPoint:point1 controlPoint:CGPointMake(150, -30)];
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=lineColor.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 2;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];
}




- (void)TheFirstAnimation{
    UIBezierPath *_path;
    
    //贝塞尔曲线,以下是4个角的位置，相对于_testView1
    CGPoint point1= CGPointMake(10, 20);
    CGPoint point2= CGPointMake(ScreenWidth - 10, 20);
    CGPoint point3= CGPointMake(ScreenWidth - 10, ScreenHeight - 10);
    CGPoint point4= CGPointMake(10, ScreenHeight - 10);
    
    _path=[UIBezierPath bezierPath];
    [_path moveToPoint:point1];//移动到某个点，也就是起始点
    [_path addLineToPoint:point2];
    [_path addLineToPoint:point3];
    [_path addLineToPoint:point4];
    [_path addLineToPoint:point1];
    
    //controlPoint控制点，不等于曲线顶点
    //    [_path addQuadCurveToPoint:point1 controlPoint:CGPointMake(150, -30)];
    
    CAShapeLayer *shapeLayer=[CAShapeLayer layer];
    shapeLayer.path=_path.CGPath;
    shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充颜色
    shapeLayer.strokeColor=lineColor.CGColor;//边框颜色
    [self.layer addSublayer:shapeLayer];
    
    //动画
    CABasicAnimation *pathAniamtion = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    // 时间
    pathAniamtion.duration = 2;
    pathAniamtion.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAniamtion.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAniamtion.toValue = [NSNumber numberWithFloat:1.0];
    pathAniamtion.autoreverses = NO;
    [shapeLayer addAnimation:pathAniamtion forKey:nil];
}


@end
