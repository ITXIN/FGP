//
//  FGDiffcultyCandidataAnswerButton.m
//  FGProject
//
//  Created by 鑫龙魂 on 2018/9/9.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGDiffcultyCandidataAnswerButton.h"
#import "WaterRippleView.h"
@implementation FGDiffcultyCandidataAnswerButton

- (void)setupWithFrame:(CGRect)frame {
    self.myWaterView = [[WaterRippleView alloc] initWithFrame:self.bounds
                                              mainRippleColor:[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1]
                                             minorRippleColor:[UIColor colorWithRed:84/255.0f green:200/255.0f blue:120/255.0f alpha:1]
                                            mainRippleoffsetX:1.0f
                                           minorRippleoffsetX:1.1f
                                                  rippleSpeed:2.0f
                                               ripplePosition:0.0f//高度
                                              rippleAmplitude:5.0f];
    self.myWaterView.backgroundColor = UIColor.clearColor;
    self.myWaterView.userInteractionEnabled = YES;
    [self addSubview:self.myWaterView];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        [self setupWithFrame:frame];
        
        self.actionBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:btn];
            btn.frame = self.bounds;
            btn;
        });
        
        self.userInteractionEnabled = YES;
        self.actionBtn.titleLabel.font = [UIFont boldSystemFontOfSize:38.f];
        [ self.actionBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        self.actionBtn.backgroundColor = UIColor.clearColor;
        self.layer.cornerRadius = (frame.size.height)/2;
        self.layer.masksToBounds = YES;
        self.isEnd = NO;
    }
    return self;
}


- (NSArray *)getRGBDictionaryByColor:(UIColor *)originColor
{
    CGFloat r=0,g=0,b=0,a=0;
    if ([self respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
        [originColor getRed:&r green:&g blue:&b alpha:&a];
    }
    else {
        const CGFloat *components = CGColorGetComponents(originColor.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }
    
    return @[@(r),@(g),@(b)];
}

- (UIColor *)getColorWithColor:(UIColor *)beginColor andCoe:(double)coe andMarginArray:(NSArray<NSNumber *> *)marginArray {
    NSArray *beginColorArr = [self getRGBDictionaryByColor:beginColor];
    double red = [beginColorArr[0] doubleValue] + coe * [marginArray[0] doubleValue];
    double green = [beginColorArr[1] doubleValue]+ coe * [marginArray[1] doubleValue];
    double blue = [beginColorArr[2] doubleValue] + coe * [marginArray[2] doubleValue];
    return RGB(abs(red), abs(green), abs(blue));
    
}

- (void)stopWaterRipper{
    self.isEnd = NO;
    [self.myWaterView.layer removeAllAnimations];
}

- (void)pauseWaterRipper{
    self.isEnd = NO;
    // 当前时间（暂停时的时间）
    // CACurrentMediaTime() 是基于内建时钟的，能够更精确更原子化地测量，并且不会因为外部时间变化而变化（例如时区变化、夏时制、秒突变等）,但它和系统的uptime有关,系统重启后CACurrentMediaTime()会被重置
    CFTimeInterval pauseTime = [self.myWaterView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 停止动画
    self.myWaterView.layer.speed = 0;
    // 动画的位置（动画进行到当前时间所在的位置，如timeOffset=1表示动画进行1秒时的位置）
    self.myWaterView.layer.timeOffset = pauseTime;
}

- (void)continueWaterRipper{
    self.isEnd = NO;
    // 动画的暂停时间
    CFTimeInterval pausedTime = self.myWaterView.layer.timeOffset;
    // 动画初始化
    self.myWaterView.layer.speed = 1;
    self.myWaterView.layer.timeOffset = 0;
    self.myWaterView.layer.beginTime = 0;
    // 程序到这里，动画就能继续进行了，但不是连贯的，而是动画在背后默默“偷跑”的位置，如果超过一个动画周期，则是初始位置
    // 当前时间（恢复时的时间）
    CFTimeInterval continueTime = [self.myWaterView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    // 暂停到恢复之间的空档
    CFTimeInterval timePause = continueTime - pausedTime;
    // 动画从timePause的位置从动画头开始
    self.myWaterView.layer.beginTime = timePause;
}

- (void)startWaterRipper{    
    self.myWaterView.ripplePosition = 0.0;
    self.isEnd = NO;
    self.myWaterView.frame = self.bounds;
    [UIView animateWithDuration:MathCompreOfChallengeTimerLevelThree animations:^{
        self.myWaterView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }completion:^(BOOL finished) {
        if (finished) {
            self.isEnd = YES;
        }
    }];
}


@end
