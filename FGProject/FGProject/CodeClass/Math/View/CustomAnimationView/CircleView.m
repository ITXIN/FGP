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
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        colorArr = @[[UIColor purpleColor],[UIColor yellowColor],[UIColor cyanColor],[UIColor greenColor],[UIColor blueColor],[UIColor redColor],RGBA(24, 185, 77, 1),RGBA(0, 255, 255, 1),RGBA(255, 0, 0, 1)];
        
        radarView = [[CARadarView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth(frame)+100, CGRectGetHeight(frame)+100)];
        [self addSubview:radarView];
        
        self.waterWaveView = [[WaterWaveView alloc]initWithFrame:self.bounds];
        [self addSubview:self.waterWaveView];
        
        radarView.center = self.waterWaveView.center;
    }
    return self;
}

- (void)circleViewWillApper
{
    [self.waterWaveView.timer setFireDate:[NSDate distantPast]];
    //100是按100道题水充满,可以设置其他的
    [self updatCircleviewData];
    [self.waterWaveView showAnimationOfWaterWave];
    [radarView startAnimation];
}
- (void)circleViewWillDisapper
{
    [radarView stopAnimation];
    [self.waterWaveView.timer setFireDate:[NSDate distantFuture]];
    [self.layer removeAllAnimations];
}
- (void)updatCircleviewData{
    self.waterWaveView.count = [[FGMathOperationManager shareMathOperationManager] getCurrentDateHasDone];
    self.waterWaveView.waveHeight = self.waterWaveView.frame.size.height- self.waterWaveView.frame.size.height*self.waterWaveView.count/DATA_WAVE_HEIGHT_SCALE;
}

@end
