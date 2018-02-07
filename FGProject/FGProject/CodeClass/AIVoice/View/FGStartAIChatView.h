//
//  FGStartAIChatView.h
//  FGProject
//
//  Created by Bert on 2016/12/7.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Waver.h"

@protocol FGStartAIChatViewDelegate <NSObject>
- (void)startBtnAction;
@end


@interface FGStartAIChatView : UIView
@property (nonatomic, strong) Waver * waver;//声波
@property (nonatomic,strong) UIButton *startBtn;
@property (nonatomic,assign) id <FGStartAIChatViewDelegate> startAIChatDelegate;
@property (nonatomic,strong) CAShapeLayer *solidLine;
@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) CAShapeLayer *circleRightHalfLayer;
@property (nonatomic,strong) CAShapeLayer *circleLeftHalfLayer;
@property (nonatomic,strong) CAShapeLayer *lineLeftLayer;

@property (nonatomic,strong) UIButton *stopBtn;

- (void)startWaveWithVolume:(NSInteger)volume;
- (void)endWave;
@end
