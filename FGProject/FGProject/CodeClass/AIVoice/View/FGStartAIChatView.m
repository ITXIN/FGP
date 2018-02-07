//
//  FGStartAIChatView.m
//  FGProject
//
//  Created by Bert on 2016/12/7.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGStartAIChatView.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@implementation FGStartAIChatView

- (Waver *)waver
{
    if (!_waver)
    {
        _waver = [[Waver alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.frame)-20)/2, CGRectGetWidth(self.frame), 20)];
                                  
    }
    return _waver;
}

- (UIButton *)startBtn
{
    if (!_startBtn)
    {
        _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startBtn.frame = CGRectMake(0, 0, 45, 45);
        _startBtn.center = _waver.center;
//        [_startBtn setImage:[UIImage imageNamed:@"startAI"] forState:UIControlStateHighlighted];
        [_startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

/*
 CAShapeLayer 继承与CALayer( 主要用于设置图层的形状)
 
 CAShapeLayer对象属性列表
 属性名	描述
 path	CGPathRef 对象，图形边线路径
 lineWidth	边线的宽度
 strokeColor	边线的颜色
 lineDashPattern	设置边线的样式，默认为实线，该数组为一个NSNumber数组，数组中的数值依次表示虚线中，单个线的长度，和空白的长度，如:数组@[2,2,3,4] 表示 有长度为2的线，长度为2的空白，长度为3的线，长度为4的空白 不断循环后组成的虚线。如图：lineDashPatttern￼
 lineDashPhase	边线样式的起始位置，即，如果lineDashPattern设置为@[2,2,3,4],lineDashPhase即为第一个长度为2的线的起始位置
 lineCap	线终点的样式，默认 kCALineCapButt kCALineCapButt￼ kCAlineCapRound kCAlineCapRound￼ kCALineCapSquare kCALineCapSquare￼
 lineJoin	线拐点处的样式，默认 kCALineJoinMiter kCALineJoinMite￼ kCALineJoinRound kCALineJoinRound￼ kCALineJoinBevel kCALineJoinBeve￼
 strokeStart strokeEnd	CGFloat类型，[0,1] 表示画边线的起点和终点（即在路径上的百分比）
 fillColor	CGColorRef对象，图形填充色，默认为黑色
 http://www.cnblogs.com/jaesun/p/iOS-CAShapeLayerUIBezierPath-hua-xian.html
 
 [circlePath addQuadCurveToPoint:(CGPoint){center.x-smallRadius,center.y} controlPoint:(CGPoint){center.x,center.y+smallRadius+circlePath.lineWidth}];//曲线
 */

- (CAShapeLayer *)solidLine
{
    if (!_solidLine) {
    
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.startBtn.bounds];
        _solidLine =  [CAShapeLayer layer];
        _solidLine.frame = self.startBtn.bounds;
        _solidLine.strokeEnd = 1.0f;
        _solidLine.strokeStart = 0.0f;
        _solidLine.path = path.CGPath;
        _solidLine.fillColor = [UIColor clearColor].CGColor;
        _solidLine.lineWidth = 2.0f;
        _solidLine.strokeColor = [UIColor whiteColor].CGColor;
        [_solidLine removeAllAnimations];
        
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.duration = 0.5f;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = NO;
        [_solidLine addAnimation:pathAnima forKey:@"strokeEndAnimation"];
        
        
        CGPoint center = CGPointMake(CGRectGetWidth(self.startBtn.frame)/2, CGRectGetWidth(self.startBtn.frame)/2);
        CGFloat lineH = 10;
        CGFloat smallRadius = 5;
        CGFloat bigRadius = 10;
        CGFloat lineW = 5;
        

        for (int i = 0; i < 4; i ++)
        {
            
            UIBezierPath *circlePath = [UIBezierPath bezierPath];
            circlePath.lineWidth = 2.0;
            circlePath.lineCapStyle = kCGLineCapRound;
            circlePath.lineJoinStyle = kCGLineJoinRound;
            
            
            CAShapeLayer *circleLayer = [CAShapeLayer layer];
            circleLayer.lineCap = kCALineCapRound;
            circleLayer.lineJoin =  kCALineJoinRound;
            // 设置填充颜色
            circleLayer.fillColor = [UIColor clearColor].CGColor;
            // 设置线宽
            circleLayer.lineWidth = 2.0;
            // 设置线的颜色
            circleLayer.strokeColor = [UIColor whiteColor].CGColor;
            circleLayer.strokeEnd = 1;
            circleLayer.strokeStart = 0.0;
            
            if (i == 0)//竖椭圆
            {
                //从下半部开始顺时针绘制
                [circlePath moveToPoint:(CGPoint){center.x+smallRadius,center.y}];
              
                
                [circlePath addArcWithCenter:center radius:smallRadius startAngle:0 endAngle:M_PI clockwise:YES];
                
                //左边竖线
                [circlePath addQuadCurveToPoint:CGPointMake(center.x-smallRadius, center.y-lineH) controlPoint:CGPointMake(center.x-smallRadius, center.y-lineH/2)];
                
                //上半圆
                [circlePath addArcWithCenter:(CGPoint){center.x,center.y- lineH} radius:smallRadius startAngle:M_PI endAngle:2*M_PI clockwise:YES];
                
                //右边竖线
                [circlePath addQuadCurveToPoint:CGPointMake(center.x+smallRadius, center.y) controlPoint:CGPointMake(center.x+smallRadius, center.y-lineH/2)];
                self.circleLayer = circleLayer;
                
            }else if (i == 1)//下右边半圆及竖线横线
            {
                [circlePath addArcWithCenter:center radius:bigRadius startAngle:0 endAngle:M_PI/2 clockwise:YES];
                [circlePath addLineToPoint:CGPointMake(center.x, center.y+bigRadius+lineH/2)];
                [circlePath addLineToPoint:CGPointMake(center.x+lineW, center.y+bigRadius+lineH/2)];
                
                self.circleRightHalfLayer = circleLayer;
            }else if (i == 2)
            {
                //下左边半圆
                [circlePath addArcWithCenter:center radius:bigRadius startAngle:M_PI endAngle:M_PI/2 clockwise:NO];
                
                self.circleLeftHalfLayer = circleLayer;
            }else if (i == 3)
            {

                //左边横线
                [circlePath moveToPoint:CGPointMake(center.x-lineW, center.y+bigRadius+lineH/2)];
                [circlePath addLineToPoint:(CGPoint){center.x,center.y+bigRadius+lineH/2}];
                
                self.lineLeftLayer = circleLayer;
                
            }
            
            circleLayer.path = circlePath.CGPath;
            
            CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnima.duration = 0.5f;
            pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
            pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
            pathAnima.fillMode = kCAFillModeForwards;
            pathAnima.removedOnCompletion = YES;
            [circleLayer addAnimation:pathAnima forKey:@"strokeEndAnimation1"];
            
        }
        
        
       
    }
    
    return _solidLine;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.opaque = NO;
//        self.stopBtn = ({
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [self addSubview:btn];
//            [btn setImage:[UIImage imageNamed:@"backToRootVC"] forState:UIControlStateNormal];
//            btn;
//        });
//        
//        [self.stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.mas_equalTo(self);
//            make.size.mas_equalTo(CGSizeMake(45, 45));
//        }];

    }
    return self;
}

#pragma mark -
#pragma mark --- startBtnClick
- (void)startBtnClick:(UIButton*)sender
{
    //防止和背景图片重叠
//    [self clearLayers];
    [self.startBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    if (self.startAIChatDelegate && [self.startAIChatDelegate respondsToSelector:@selector(startBtnAction)])
    {
        [self.startAIChatDelegate startBtnAction];
    }
    
}

#pragma mark -
#pragma mark --- 初始化声波
- (void)startWaveWithVolume:(NSInteger)volume
{
    if (![self.subviews containsObject:self.waver])
    {
        NSLog(@"-----wave %p",self.waver);
       
        [self addSubview:self.waver];
        [self addSubview:self.startBtn];

    }
//    NSLog(@"-----startWaveWithVolume %ld",volume);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.waver.alpha = 1.0;
        self.startBtn.alpha = 1.0;
        

        [self.startBtn setImage:[UIImage imageNamed:@"startAI"] forState:UIControlStateHighlighted];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.startBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            self.startBtn.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.5 animations:^{
                self.startBtn.alpha = 0.0;
                [self clearLayers];
            }completion:^(BOOL finished) {
                
            }];
            
        }];
      
        
        
        
       
        __weak Waver * weakWaver = self.waver;
        self.waver.waverLevelCallback = ^() {
            if (volume != -1)//-1 其实是最后一次状态,并没有获取实时音调
            {
                CGFloat normalizedValue = pow (10,volume/40);
                weakWaver.level = normalizedValue;
            }
            
        };
    });
}

#pragma mark -
#pragma mark --- 结束声波
- (void)endWave
{
    self.startBtn.alpha = 0.0;
    self.waver.alpha = 1.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.waver.alpha = 0.0;
        self.startBtn.alpha = 1.0;
    } completion:^(BOOL finished) {
        
        [self.waver.layer removeAllAnimations];
        self.waver.waverLevelCallback = nil;
        [self.waver removeFromSuperview];
        self.waver = nil;
        
        [self addLayers];
        
        
        
    }];
}
- (void)addLayers
{
    [self.startBtn.layer addSublayer:self.solidLine];
    // 将CAShaperLayer放到某个层上显示
    [self.startBtn.layer addSublayer:self.circleLayer];
    [self.startBtn.layer addSublayer:self.circleRightHalfLayer];
    [self.startBtn.layer addSublayer:self.circleLeftHalfLayer];
    [self.startBtn.layer addSublayer:self.lineLeftLayer];
    
}

- (void)clearLayers
{
    
    [self.solidLine removeAllAnimations];
    [self.solidLine removeFromSuperlayer];
    self.solidLine = nil;
    
    
    [self.circleLayer removeAllAnimations];
    [self.circleLayer removeFromSuperlayer];
    self.circleLayer = nil;
    
    [self.circleRightHalfLayer removeAllAnimations];
    [self.circleRightHalfLayer removeFromSuperlayer];
    self.circleRightHalfLayer = nil;
    
    [self.circleLeftHalfLayer removeAllAnimations];
    [self.circleLeftHalfLayer removeFromSuperlayer];
    self.circleLeftHalfLayer = nil;
    
    [self.lineLeftLayer removeAllAnimations];
    [self.lineLeftLayer removeFromSuperlayer];
    self.lineLeftLayer = nil;
}

@end
