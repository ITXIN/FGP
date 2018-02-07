//
//  CircleView.m
//  FGProject
//
//  Created by Bert on 16/2/4.
//  Copyright © 2016年 XL. All rights reserved.
//


#import "CircleView.h"

#import "CARadarView.h"
@implementation CircleView
{
    NSArray *colorArr;
    CARadarView *radarView;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        colorArr = @[[UIColor purpleColor],[UIColor yellowColor],[UIColor cyanColor],[UIColor greenColor],[UIColor blueColor],[UIColor redColor],RGBA(24, 185, 77, 1),RGBA(0, 255, 255, 1),RGBA(255, 0, 0, 1)];
        
        radarView = [[CARadarView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(frame)+100, CGRectGetHeight(frame)+100)];
        [self addSubview:radarView];

        self.waterWaveView = [[WaterWaveView alloc]initWithFrame:self.bounds];
        [self addSubview:self.waterWaveView];

        radarView.center = self.waterWaveView.center;
    }
    return self;
}

#pragma mark -
#pragma mark --- 绘制波圈
- (void)drawCircleWithFrame:(CGRect)frame
{
    CGRect rect ;
    rect.size.width = frame.size.width;
    rect.size.height = frame.size.height;
    //    [RGBA(22, 163, 130,1) setFill];
    //    UIRectFill(rect);
    NSInteger pulsingCount = 5;
    double animationDuration = 3;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = ((UIColor *)colorArr[arc4random()%colorArr.count]).CGColor;
        pulsingLayer.borderWidth = 1;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.4;
        scaleAnimation.toValue = @2.2;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    
    if (self.layer.sublayers.count == 2)
    {
        [self.layer.sublayers[1] removeFromSuperlayer];
    }
    [self.layer addSublayer:animationLayer];
    //    self.layer.masksToBounds = YES;//这个会切掉波圈
    self.backgroundColor = [UIColor clearColor];//防止会出现黑色
}

- (void)circleViewWillApper
{
    [self.waterWaveView.timer setFireDate:[NSDate distantPast]];
//    self.waterWaveView.count = [[NSUserDefaults standardUserDefaults]integerForKey:[[FGDateSingle shareInstance] curretDate]];
//    self.waterWaveView.count = [[FGMathOperationManager shareMathOperationManager] getCurrentDateHasDone];
//    self.waterWaveView.waveHeight = self.waterWaveView.frame.size.height- self.waterWaveView.frame.size.height*self.waterWaveView.count/DATA_WAVE_HEIGHT_SCALE;//100是按100道题水充满,可以设置其他的
    [self updatCircleviewData];
    [self.waterWaveView showAnimationOfWaterWave];
//    [self drawCircleWithFrame:self.frame];
    
    [radarView startAnimation];
}
- (void)circleViewWillDisapper
{
    [radarView stopAnimation];
    [self.waterWaveView.timer setFireDate:[NSDate distantFuture]];
    [self.layer removeAllAnimations];
}
- (void)updatCircleviewData{
//    self.waterWaveView.count = [[NSUserDefaults standardUserDefaults]integerForKey:[[FGDateSingle shareInstance] curretDate]];
    self.waterWaveView.count = [[FGMathOperationManager shareMathOperationManager] getCurrentDateHasDone];
    self.waterWaveView.waveHeight = self.waterWaveView.frame.size.height- self.waterWaveView.frame.size.height*self.waterWaveView.count/DATA_WAVE_HEIGHT_SCALE;
}

@end
