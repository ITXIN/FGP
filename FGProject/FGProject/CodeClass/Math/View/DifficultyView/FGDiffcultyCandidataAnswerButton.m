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
   
    self.myWaterView = [[WaterRippleView alloc] initWithFrame:frame
                                                            mainRippleColor:[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1]
                                                           minorRippleColor:[UIColor colorWithRed:84/255.0f green:200/255.0f blue:120/255.0f alpha:1]
                                                          mainRippleoffsetX:1.0f
                                                         minorRippleoffsetX:1.1f
                                                                rippleSpeed:2.0f
                                                             ripplePosition:0.0f//高度
                                                            rippleAmplitude:5.0f];
    self.myWaterView.backgroundColor = UIColor.clearColor;
    self.myWaterView.userInteractionEnabled = YES;
    [self insertSubview:self.myWaterView atIndex:0];
}


- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
       
        [self setupWithFrame:frame];
        self.userInteractionEnabled = YES;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:38.f];
        [self setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"countNum-bg"] forState:UIControlStateNormal];
        self.backgroundColor = UIColor.clearColor;
        self.layer.cornerRadius = (frame.size.height)/2;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)waterWaveAnimation{
    self.myWaterView.ripplePosition = 0.0;
    self.isEnd = NO;
    self.myWaterView.mainRippleColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1];
    self.myWaterView.minorRippleColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1];
    [UIView animateWithDuration:10 animations:^{
        self.myWaterView.minorRippleColor = UIColor.redColor;
        self.myWaterView.mainRippleColor = UIColor.redColor;
    }];
    [self startAnimateWave];
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

- (void)startAnimateWave{
    self.myWaterView.ripplePosition ++;
    if (self.myWaterView.ripplePosition >= CGRectGetHeight(self.frame)){
        self.isEnd = YES;
        return ;
    }else{
        [self performSelector:@selector(startAnimateWave) withObject:nil afterDelay:MathCompreOfChallengeTimerLevelThree/CGRectGetHeight(self.frame)];
    }
}

@end
