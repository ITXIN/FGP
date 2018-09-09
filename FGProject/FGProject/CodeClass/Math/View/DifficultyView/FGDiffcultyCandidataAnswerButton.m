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
                                                             ripplePosition:100.0f//高度
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
//        [self setBackgroundImage:[UIImage imageNamed:@"countNum-bg"] forState:UIControlStateNormal];
        self.backgroundColor = UIColor.clearColor;
        [self addTarget:self action:@selector(candidateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return self;
}

- (void)candidateBtnClick:(UIButton*)sender{
    NSLog(@"---buton--%@",sender);
}


- (id)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
//    if (hitView == self)
//    {
        return self;
//    }
//    else
//    {
//        return hitView;
//    }
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [super addTarget:target action:action forControlEvents:controlEvents];
    
}


- (void)waterWaveAnimation{
    
//    self.myWaterView.ripplePosition = 0.0;
//    [self startAnimateWave];
}
- (void)startAnimateWave{
    NSLog(@"---start--");
    
    self.myWaterView.ripplePosition ++;
    
    if (self.myWaterView.ripplePosition >= CGRectGetHeight(self.frame)){
        return ;
    }else{
        [self performSelector:@selector(startAnimateWave) withObject:nil afterDelay:10/CGRectGetHeight(self.frame)];
        
    }
}
- (void)animateWave{
    NSLog(@"---timer--");
}

@end
